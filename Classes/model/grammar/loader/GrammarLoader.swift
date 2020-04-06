//
// The MIT License (MIT)
//
// Copyright © 2019 NoodleOfDeath. All rights reserved.
// NoodleOfDeath
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation
import SwiftyXMLParser

/// Data structure designed to index and load grammar packages found in
/// specified search paths.
open class GrammarLoader: NSObject {
    
    public typealias This = GrammarLoader
    
    public typealias Pattern = Grammar.Pattern
    public typealias Metadata = Grammar.Metadata
    public typealias MetadataOption = Grammar.MetadataOption
    public typealias Identifier = Grammar.Identifier
    
    /// Common string constants used by this class.
    public struct defaults {
        public static let packageExtension = "grammar"
        public static let packageConfigFile = "grammar.xml"
    }
    
    /// Common XML element tag names used in grammar definition files.
    public enum XMLTagName: String {
        case grammar
        case rules
        case rule
        case definition
        case word
        case metadata
        case component
        case group
        case `break`
        case string
        case description
    }
    
    /// Common XML attribute names used in grammar definition files.
    public enum XMLAttributeName: String {
        case extends
        case id
        case precedence
        case options
        case category
        case description
    }
    
    /// Search paths in which to look for grammar files and packages.
    open var searchPaths = [String]()
    
    /// Constructs a new grammar loader with the specified search paths.
    ///
    /// - Parameters:
    ///     - searchPaths: to initialize this grammar loader with.
    ///     - derivedDataDirectory:
    public init(searchPaths: String...) {
        self.searchPaths = searchPaths
    }
    
    /// Constructs a new grammar loader with the specified search paths.
    ///
    /// - Parameters:
    ///     - searchPaths: to initialize this grammar loader with.
    ///     - derivedDataDirectory:
    public init(searchPaths: [String]) {
        self.searchPaths = searchPaths
    }
    
    /// Returns a specified path ending with exactly one extension occurrence of
    /// `This.PackageExtension`.
    ///
    /// - Parameters:
    ///     - path: to format.
    ///     - packageExtension:
    ///     - packageConfigFile:
    /// - Returns: path ending with exactly one extension occurrence of
    /// `This.PackageExtension`.
    open class func format(packageName path: String, packageExtension: String = defaults.packageExtension, packageConfigFile: String = defaults.packageConfigFile) -> String {
        if path.endIndex == path.range(of: packageExtension)?.upperBound ||
            path.endIndex == path.range(of: packageExtension)?.upperBound {
            return path
        }
        return format(configFilePath: String(format: "%@.%@", path, packageExtension))
    }
    
    /// Returns a specified path ending with exactly one config file occurrence
    /// of `This.PackageConfigFile`.
    ///
    /// - Parameters:
    ///     - path: to format.
    ///     - packageConfigFile:
    /// - Returns: path ending with exactly one config file occurrence of
    /// `This.PackageConfigFile`.
    open class func format(configFilePath path: String, packageConfigFile: String = defaults.packageConfigFile) -> String {
        if path.endIndex == path.range(of: packageConfigFile)?.upperBound {
            return path
        }
         return path +/ packageConfigFile
    }

    ///
    ///
    /// - Parameters:
    ///     - id:
    /// - Returns:
    open func grammarPackage(for id: String) -> String? {
        var filename = ""
        for searchPath in searchPaths {
            filename = This.format(packageName: searchPath +/ id)
            if FileManager.default.fileExists(atPath: filename) {
                return filename
            }
        }
        return nil
    }
    
    /// Searches for and loads a grammar associated with a specified
    /// identifier.
    ///
    /// - Parameters:
    ///     - id: of the grammar to search for and load.
    ///     - options: to use while loading the grammar.
    /// - Returns: A fully loaded grammar if one was found; `nil`, otherwise.
    open func loadGrammar(for id: String, options: Option = []) -> Grammar? {
        var grammar: Grammar?
        guard let filename = grammarPackage(for: id) else { return nil }
        guard let contents = try? String(contentsOfFile: filename) else { return nil }
        do {
            grammar = try load(node: XML.parse(contents), options: options)
        } catch {
            print(error)
        }
        return grammar
    }
    
    /// Searches for and loads a grammar associated with a specified
    /// identifier.
    ///
    /// - Parameters:
    ///     - id: of the grammar to search for and load.
    ///     - options: to use while loading the grammar.
    ///     - completionHandler: to callback when the grammar has successfully
    /// finished loading.
    /// - Returns: A fully loaded grammar if one was found; `nil`, otherwise.
    open func loadGrammar(for id: String, options: Option = [], completionHandler: @escaping (Grammar?) -> Void) {
        DispatchQueue.global().async {
            var grammar: Grammar?
            guard let filename = self.grammarPackage(for: id) else {
                completionHandler(nil)
                return
            }
            guard let contents = try? String(contentsOfFile: filename) else {
                completionHandler(nil)
                return
            }
            do {
                grammar = try self.load(node: XML.parse(contents), options: options)
            } catch {
                print(error)
            }
            DispatchQueue.main.async {
                completionHandler(grammar)
            }
        }
    }
    
    /// Loads a grammar from a root XML element.
    ///
    /// - Parameters:
    ///     - node: root XML element of a grammar definition.
    ///     - options: to use while loading the grammar.
    /// - Returns: A fully loaded grammar.
    /// - Throws:
    open func load(node: XML.Accessor, options: Option = []) -> Grammar {
        
        let root = node[XMLTagName.grammar]
        let grammar = Grammar()
        
        var rules = [String: GrammarRule]()
        
        rules[Grammar.unmatchedRuleId] = grammar.unmatchedRule
        
        if let parentName = root.attributes[XMLAttributeName.extends],
            let parentGrammar = loadGrammar(for: parentName, options: options) {
            rules = parentGrammar.rules
        }
        
        let ruleSet = root[XMLTagName.rules]
        for node in ruleSet[XMLTagName.rule] {
            guard let rule = parseXMLNode(for: grammar, node: node) else { continue }
            rule.ruleClass = rule.id.isCapitalized ? .lexerRule : .parserRule
            rules[rule.id] = rule
        }
        
        grammar.rules = rules
        
        if options.contains(.verbose) {
            print(grammar)
        }
        
        return grammar
        
    }
    
    ///
    ///
    /// - Parameters:
    ///     - node:
    ///     - rootRule:
    ///     - grammar:
    /// - Returns:
    open func parseXMLNode(for grammar: Grammar, node: XML.Accessor) -> GrammarRule? {
        guard let id = node.attributes[XMLAttributeName.id] else { return nil }
        let metadata = parseMetadata(for: node)
        let defNode = node[XMLTagName.definition]
        var definition: String
        if defNode.element?.childElements.count != 0 {
            var words = [String]()
            for word in defNode[XMLTagName.word] {
                guard let id = parse(word: word, metadata: metadata) else { continue }
                words.append(String(format: "'%@'", id.string))
                grammar.add(identifier: id)
            }
            definition = words.joined(separator: " | ")
        } else {
            definition = defNode.text ?? ""
        }
        definition = definition.replacingOccurrences(of: "\\r?\\n|\\s\\s+", with: " ", options: .regularExpression)
        guard let rule = parseCompositeRule(for: grammar,
                                            id: id,
                                            definition: definition,
                                            composite: true)
            else { return nil }
        if let precedence = node.attributes[XMLAttributeName.precedence] {
            rule.precedence = GrammarRule.Precedence(id: id, precedence)
        }
        rule.metadata = metadata
        return rule
    }
    
    ///
    ///
    /// - Parameters:
    ///     - id:
    ///     - atom:
    ///     - quantifier:
    ///     - parent:
    ///     - grammar:
    /// - Returns:
    open func parseAtom(for grammar: Grammar, id: String, definition atom: String, quantifier: String, parent: GrammarRule?) -> GrammarRule? {
        
        var atom = atom
        var quantifier = quantifier
        var componentType: GrammarRule.ComponentType = .atom
        var rule: GrammarRule?
        
        if let match = Pattern.cgExpression.firstMatch(in: atom, options: ([], .anchored)) {
            atom = atom.substring(with: match.range(at: 1))
            componentType = .expression
        } else if let match = Pattern.cgLiteral.firstMatch(in: atom, options: ([], .anchored)) {
            atom = atom.substring(with: match.range(at: 1))
            componentType = .literal
        } else if let match = Pattern.cgGroup.firstMatch(in: atom, options: ([], .anchored)) {
            atom = atom.substring(with: match.range(at: 1))
            componentType = .composite
        }
        
        if componentType == .atom {
            componentType = atom.isCapitalized ? .lexerRuleReference : .parserRuleReference
        }
        
        if componentType == .composite {
            
            var slice = ""
            var remainder = ""
            
            var tail: GrammarRule?
            var next: GrammarRule?
            
            var depth = 0
            var cursor = 0
            var ignore = false
            
            repeat {
                
                let ch = atom.char(at: cursor)
                slice += ch
                
                switch ch {
                    
                case "'", "\"":
                    ignore = !ignore
                    break
                    
                case "(":
                    depth += !ignore ? 1 : 0
                    break
                    
                case ")":
                    depth -= !ignore ? 1 : 0
                    break
                    
                default:
                    break
                    
                }
                
                cursor += 1
                
            } while depth > 0 && cursor < atom.count
            
            if depth > 0 {
                print(String(format: "WARNING: Encountered fatal unmatched parenthesis in rule definition for rule named: %@", id))
                return nil
            }
            
            if cursor < atom.count {
                
                remainder = atom.substring(from: cursor)
                if let match = Pattern.quantifier.firstMatch(in: remainder, options: ([], .anchored)) {
                    quantifier = remainder.substring(with: match.range)
                    remainder = remainder.substring(from: quantifier.count)
                }
                let altIndex = remainder.index(of: "|")
                let grpIndex = remainder.index(of: "(")
                if altIndex > 0 {
                    if grpIndex < 0 || altIndex < grpIndex {
                        let subslice = remainder.substring(from: altIndex + 1)
                        next = parseCompositeRule(for: grammar,
                                                  id: id,
                                                  definition: subslice)
                        remainder = remainder.substring(to: altIndex)
                    }
                }
                tail = parseCompositeRule(for: grammar,
                                          id: id,
                                          definition: remainder)
                
            }
            
            if slice.count > 0 {
                if let match = Pattern.cgGreedyGroup.firstMatch(in: slice) {
                    slice = slice.substring(with: match.range(at: 1))
                }
            }
            
            rule = parseCompositeRule(for: grammar,
                                      id: id,
                                      definition: slice,
                                      composite: true)
            if tail != nil {
                rule?.next = tail
            }
            if next != nil {
                parent?.enqueue(next)
            }
            
        } else {
            rule = GrammarRule(grammar: grammar,
                               id: id,
                               value: atom,
                               componentType: componentType)
        }
        
        rule?.componentType = componentType
        rule?.quantifier = Quantifier.from(quantifier)
        
        return rule
        
    }
    
    ///
    ///
    /// - Parameters:
    ///     - id:
    ///     - definition:
    ///     - parent:
    ///     - grammar:
    /// - Returns:
    open func parseSimpleRule(for grammar: Grammar, id: String, definition: String, parent: GrammarRule? = nil) -> GrammarRule? {
        var orig: GrammarRule?
        var last: GrammarRule?
        var rule: GrammarRule?
        for match in Pattern.cgAtom.matches(in: definition) {
            let pRange = match.range(at: 1) // prefix
            let aRange = match.range(at: 2) // atom
            let qRange = match.range(at: 3) // quantifier
            let prefix = pRange.location < Int.max ? definition.substring(with: match.range(at: 1)) : ""
            let atom = aRange.location < Int.max ? definition.substring(with: match.range(at: 2)) : ""
            let quantifier = qRange.location < Int.max ? definition.substring(with: match.range(at: 3)) : ""
            rule = parseAtom(for: grammar,
                             id: id,
                             definition: atom,
                             quantifier: quantifier,
                             parent: parent)
            rule?.inverted = prefix == "~"
            last?.next = rule
            last = rule
            if orig == nil { orig = rule }
        }
        return orig
    }
    
    ///
    ///
    /// - Parameters:
    ///     - id:
    ///     - definition:
    ///     - composite:
    ///     - parent:
    ///     - rootAncestor:
    ///     - grammar:
    /// - Returns:
    open func parseCompositeRule(for grammar: Grammar, id: String, definition: String, composite: Bool = false, parent: GrammarRule? = nil) -> GrammarRule? {
        
        var parent = parent
        var rule: GrammarRule?
        
        if composite {
            
            rule = GrammarRule(grammar: grammar,
                               id: id,
                               value: "",
                               componentType: .composite)
            parent = rule
            
            for match in Pattern.cgAlternative.matches(in: definition) {
                let alternative = definition.substring(with: match.range).trimmingCharacters(in: .whitespacesAndNewlines)
                if let simpleRule = parseSimpleRule(for: grammar,
                                                    id: id,
                                                    definition: alternative,
                                                    parent: parent) {
                    if let parent = parent {
                        parent.add(child: simpleRule)
                        parent.consumeQueue()
                    }
                }
            }
            
        } else {
            
            rule = parseSimpleRule(for: grammar,
                                   id: id,
                                   definition: definition,
                                   parent: parent)
            rule?.grammar = grammar
            parent?.next = rule
            
        }
        
        return rule
        
    }
    
    /// Parses a word from an XML accessor and returns an identifer represeting
    /// that word.
    ///
    /// - Parameters:
    ///     - accessor: to parse a word from.
    /// - Returns: an identifier that represents a word.
    open func parse(word accessor: XML.Accessor, metadata: Metadata? = nil) -> Identifier? {
        guard let element = accessor.element else { return nil }
        guard let string = element.childElements.count == 0 ? element.text : accessor[XMLTagName.string].text else { return nil }
        let detailedDescription = accessor.attributes[XMLAttributeName.description] ?? accessor[XMLTagName.description].text
        if detailedDescription == "Fuck" {

        }
        return Identifier(string: string, detailedDescription: detailedDescription, metadata: metadata)
    }
    
    /// Parses the metadata of a component.
    ///
    /// - Parameters:
    ///     - metadata: accessor to parse metadata from.
    open func parseMetadata(for accessor: XML.Accessor, rule: GrammarRule? = nil) -> Metadata {
        
        let metadata = createMetadata(from: accessor.attributes)
        
        if let metadataElement = accessor[XMLTagName.metadata].element {
            var root: Metadata?
            var parent: Metadata?
            var children = [Metadata]()
            metadataElement.childElements.forEach {
                if $0.name != XMLTagName.break {
                    let component = parseMetadata(for: $0)
                    if root == nil { root = component }
                    parent?.next = component
                    parent = component
                } else {
                    if let root = root { children.append(root) }
                    root = nil
                    parent = nil
                }
            }
            if let root = root { children.append(root) }
            metadata.children = children
        }
        
        return metadata
        
    }
    
    open func parseMetadata(for element: XML.Element) -> Metadata {
        
        let metadata = createMetadata(from: element.attributes)
        
        switch element.name {
            
        case XMLTagName.component.rawValue:
            break
            
        case XMLTagName.group.rawValue:
            var root: Metadata?
            var parent: Metadata?
            var children = [Metadata]()
            element.childElements.forEach {
                if $0.name != XMLTagName.break {
                    let component = parseMetadata(for: $0)
                    if root == nil { root = component }
                    parent?.next = component
                    parent = component
                } else {
                    if let root = root { children.append(root) }
                    root = nil
                    parent = nil
                }
            }
            if let root = root { children.append(root) }
            metadata.children = children
            break
            
        default:
            break
            
        }
        return metadata
    }
    
    open func createMetadata(from attributes: [String: String]) -> Metadata {
        let id = attributes[XMLAttributeName.id]
        let options = MetadataOption.from(attributes[XMLAttributeName.options]?.split(by: "\\s*,\\s*"))
        let categories = TokenCategory.from(attributes[XMLAttributeName.category]?.split(by: "\\s*,\\s*"))
        let metadata = Metadata(id: id,
                                options: options,
                                categories: categories,
                                attributes: attributes)
        return metadata
    }
    
}
