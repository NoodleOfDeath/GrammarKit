//
// The MIT License (MIT)
//
// Copyright © 2020 NoodleOfDeath. All rights reserved.
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

/// Data structure designed to index and load grammar packages found in
/// specified search paths.
open class GrammarLoader: NSObject {
    
    public typealias This = GrammarLoader

    public typealias Pattern = Grammar.Pattern
    public typealias Metadata = Grammar.Metadata
    public typealias MetadataOption = Grammar.MetadataOption
    public typealias Identifier = Grammar.Identifier

    public typealias RuleType = GrammarRule.RuleType
    
    /// Common string constants used by this class.
    public struct defaults {
        public static let packageExtension = "grammar"
        public static let packageConfigFile = "grammar.g"
    }

    public enum AttributeKey: String {
        case id
        case definition
        case options
        case precedence
        case description
        case metadata
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

    /// Returns the grammar package name for a grammar id string, or `nil`,
    /// if no such package exists in the search paths.
    ///
    /// - Parameters:
    ///     - id: of the grammar package name to generate.
    /// - Returns: the grammar package name for a grammar id string, or `nil`,
    /// if no such package exists in the search paths.
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
    open func loadGrammar(for id: String) -> Grammar? {
        guard let filename = grammarPackage(for: id) else { return nil }
        guard let contents = try? String(contentsOfFile: filename) else { return nil }
        return load(string: contents)
    }

    open func load(string: String) -> Grammar? {

        let grammar = Grammar()

        var rules = [String: GrammarRule]()

        let string = string
            .replacingOccurrences(of: "(//|#).*/\\*.*?\\*/", with: "", options: .regularExpression)
            .replacingOccurrences(of: "[ \\t]+", with: " ", options: .regularExpression)

        if let match = Pattern["grammar"]?.firstMatch(in: string) {
            grammar.name = string.substring(with: match.range(at: 1))
        } else {
            print("ERROR: Unable to find grammar header")
           return nil
        }

        Pattern["import"]?.enumerateMatches(in: string) { (match, _, _) in
            guard let match = match else { return }
            let parentName = string.substring(with: match.range(at: 1))
            if let parentGrammar = self.loadGrammar(for: parentName) {
                rules += parentGrammar.rules
            }
        }

        Pattern["rule"]?.enumerateMatches(in: string, options: ([.anchorsMatchLines, .dotMatchesLineSeparators], [.withTransparentBounds])) { (match, _, _) in
            guard let match = match else { return }
            let range1 = match.range(at: 1)
            let range2 = match.range(at: 2)
            let range3 = match.range(at: 3)
            let range4 = match.range(at: 4)
            let id = string.substring(with: range2)
            var attributes = [String: Any]()
            if range3.length > 0 {
                let jsonString = string.substring(with: range3)
                if let data = jsonString.data(using: .utf8),
                    let attr = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any] {
                    attributes = attr
                }
            }
            let definition = (range4.length > 0 ? string.substring(with: range4) : "").replacingOccurrences(of: "(\\r?\\n|\\s)+", with: " ", options: .regularExpression).trimmed(true)
            if range1.length > 0 {
                var options = attributes[AttributeKey.options] as? [String] ?? []
                options.append("fragment")
                attributes[AttributeKey.options] = options
            }
            guard let rule = createRule(with: id, attributes: attributes, definition: definition, for: grammar) else { return }
            guard !rule.infinitelyRecursive() else {
                print("WARNING: Skipping infinitely recursive rule: \(rule)")
                return
            }
            rules[id] = rule
        }

        grammar.rules = rules

        return grammar

    }

    open func createRule(with id: String, attributes: [String: Any] = [:], definition: String, for grammar: Grammar) -> GrammarRule? {

        var definition = definition
        let metadata = createMetadata(for: id, from: attributes)
        if  metadata.has(option: .dictionary),
            let data = definition.data(using: .utf8) {
            if let dictionary = (try? JSONSerialization.jsonObject(with: data, options: [.allowFragments])) as? [[String: Any]] {
                var words = [String]()
                for dict in dictionary {
                    guard let word = parseWord(from: dict) else { continue }
                    words.append(String(format: "'%@'", word.string))
                    grammar.add(word: word)
                }
                definition = words.joined(separator: " | ")
            }
        }

        guard let rule = parseCompositeRule(for: grammar, id: id,
                                            definition: definition,
                                            type: id.isCapitalized ? .lexerRule : .parserRule)
            else { return nil }

        if let precedence = attributes[AttributeKey.precedence] as? [String] {
            rule.precedence = GrammarRule.Precedence(id: id, precedence)
        }
        rule.metadata = metadata

        return rule


    }
    
    /// Parses an atom component from a definition string.
    ///
    /// - Parameters:
    ///     - grammar: to assign this grammar rule to.
    ///     - id: of this grammar rule.
    ///     - atom: string.
    ///     - quantifier: of this atom component.
    ///     - parent: grammar rule.
    /// - Returns: a grammar rule parsed from an atomic string.
    open func parseAtom(for grammar: Grammar, id: String, definition atom: String, quantifier: String, parent: GrammarRule?) -> GrammarRule? {
        
        var atom = atom
        var quantifier = quantifier
        var type: RuleType = .atom
        var rule: GrammarRule?
        
        if let match = Pattern["cgExpression"]?.firstMatch(in: atom, options: ([], .anchored)) {
            atom = atom.substring(with: match.range(at: 1))
            type = .expression
        } else if let match = Pattern["cgLiteral"]?.firstMatch(in: atom, options: ([], .anchored)) {
            atom = atom.substring(with: match.range(at: 1))
            type = .literal
        } else if let match = Pattern["cgGroupReference"]?.firstMatch(in: atom, options: ([], .anchored)) {
            atom = atom.substring(with: match.range(at: 1))
            type = .captureGroupReference
        } else if let match = Pattern["cgGroup"]?.firstMatch(in: atom, options: ([], .anchored)) {
            atom = atom.substring(with: match.range(at: 1))
            type = .composite
        }

        // Rule is not am expression, literal, or composite atom, and therefore
        // must be a lexer/parser rule reference.
        if type == .atom {
            type = atom.isCapitalized ? .lexerRuleReference : .parserRuleReference
        }

        var groupName: String?

        // If rule is composite (i.e. contains parenthesis), search for nests.
        if type == .composite {

            var slice = ""
            var remainder = ""
            
            var tail: GrammarRule?
            var nextChild: GrammarRule?
            
            var depth = 0
            var dx = 0
            var ignore = false

            if let match = Pattern["cgGroupName"]?.firstMatch(in: atom, options: ([], [])) {
                let range = match.range(at: 1)
                if range.isValid {
                    groupName = atom.substring(with: range)
                    depth += 1
                    dx += match.range.length + 1
                }
            }

            repeat {
                
                let char = atom.char(at: dx)
                slice += char
                
                switch char {
                    
                case "'", "\"":
                    // Toggle ignore flag inside strings.
                    ignore = !ignore

                case "(":
                    if ignore { continue }
                    // +1 nested depth.
                    depth += 1

                case ")":
                    if ignore { continue }
                    // -1 nested depth.
                    depth -= 1

                default:
                    break
                    
                }
                
                dx += 1
                
            } while depth > 0 && dx < atom.length
            
            if depth > 0 {
                print(String(format: "WARNING: Encountered fatal unmatched parenthesis in rule definition for rule named: %@. Skipping rule.", id))
                return nil
            }
            
            if dx < atom.length {
                
                remainder = atom.substring(from: dx)
                if let match = Pattern["quantifier"]?.firstMatch(in: remainder, options: ([], .anchored)) {
                    quantifier = remainder.substring(with: match.range)
                    remainder = remainder.substring(from: quantifier.length)
                }
                let altIndex = remainder.index(of: "|")
                let grpIndex = remainder.index(of: "(")
                if altIndex > 0 {
                    if grpIndex < 0 || altIndex < grpIndex {
                        let subslice = remainder.substring(from: altIndex + 1)
                        nextChild = parseCompositeRule(for: grammar, id: id, definition: subslice)
                        remainder = remainder.substring(to: altIndex)
                    }
                }
                tail = parseCompositeRule(for: grammar, id: id, definition: remainder)
                
            }

            var inverted = false
            if slice.length > 0 {
                if let match = Pattern["cgGreedyGroup"]?.firstMatch(in: slice, options: ([], .anchored)) {
                    inverted = slice.substring(with: match.range(at: 1)) == "~"
                    slice = slice.substring(with: match.range(at: 2))
                }
            }
            
            rule = parseCompositeRule(for: grammar, id: id, definition: slice, type: .composite)
            rule?.next ?= tail
            rule?.inverted = inverted
            if let nextChild = nextChild {
                parent?.enqueue(nextChild)
            }
            
        } else {
            var id = id
            if let prefix = parent?.id, let count = parent?.count {
                id = "\(prefix).\(count)"
            }
            rule = GrammarRule(grammar: grammar, id: id, value: atom, type: type)
        }
        
        rule?.type = type
        rule?.groupName = groupName
        rule?.quantifier = Quantifier(quantifier)
        
        return rule
        
    }
    
    /// Parses a simple rule that consists of atom components.
    ///
    /// - Parameters:
    ///     - grammar: of this grammar rule.
    ///     - id: of this grammar rule.
    ///     - definition: of this grammar rule.
    ///     - parent: of this grammar rule.
    /// - Returns: a simple grammar rule instance parsed from `definition`.
    open func parseSimpleRule(for grammar: Grammar, id: String, definition: String, parent: GrammarRule? = nil) -> GrammarRule? {
        var orig: GrammarRule?
        var last: GrammarRule?
        var rule: GrammarRule?
        guard let expr = Pattern["cgAtom"] else { return nil }
        for match in expr.matches(in: definition) {
            let inverted    = definition.substring(with: match.range(at: 1))
            let atom        = definition.substring(with: match.range(at: 2))
            let quantifier  = definition.substring(with: match.range(at: 3))
            rule = parseAtom(for: grammar, id: id, definition: atom,
                             quantifier: quantifier, parent: parent)
            rule?.inverted = (inverted == "~")
            last?.next = rule
            last = rule
            if orig == nil { orig = rule }
        }
        return orig
    }
    
    /// Parses a composite rule that contains alternatives from a string
    /// definition.
    ///
    /// - Parameters:
    ///     - grammar: of this grammar rule.
    ///     - id: of this grammar rule.
    ///     - definition: of this grammar rule.
    ///     - type:  of this grammar rule.
    ///     - parent: of this grammar rule.
    /// - Returns:
    open func parseCompositeRule(for grammar: Grammar, id: String, definition: String, type: GrammarRule.RuleType? = nil, parent: GrammarRule? = nil) -> GrammarRule? {
        
        var parent = parent
        var rule: GrammarRule?
        
        if let type = type {

            rule = GrammarRule(grammar: grammar, id: id, value: "", type: type)
            parent = rule

            guard let expr  = Pattern["cgAlternative"] else { return nil }
            for match in expr.matches(in: definition) {
                let alternative = definition.substring(with: match.range).trimmed(true)
                if let simpleRule = parseSimpleRule(for: grammar, id: id,
                                                    definition: alternative, parent: parent) {
                    if let parent = parent {
                        parent.add(child: simpleRule)
                        parent.consumeQueue()
                    }
                }
            }
            
        } else {
            
            rule = parseSimpleRule(for: grammar, id: id, definition: definition, parent: parent)
            rule?.grammar = grammar
            parent?.next = rule
            
        }
        
        return rule
        
    }

    /// Parses a word from an dictionary and returns an identifer represeting
    /// that word.
    ///
    /// - Parameters:
    ///     - dict: to parse an identifier from.
    /// - Returns: an identifier that represents a word.
    open func parseWord(from dict: [String: Any]) -> Identifier? {
        guard let string = (dict[AttributeKey.definition] ?? dict[AttributeKey.id]) as? String else { return nil }
        return Identifier(string: string, metadata: parseMetadata(for: dict))
    }

    ///
    ///
    /// - Parameters:
    ///     - word: to parse metadata from.
    /// - Returns:
    open func parseMetadata(for word: [String: Any]? = nil) -> Metadata {
        return Metadata(from: word)
    }

    ///
    ///
    /// - Parameters:
    ///     - idl
    ///     - word: to parse metadata from.
    /// - Returns:
    open func createMetadata(for id: String, from attributes: [String: Any]) -> Metadata {
        let metadata = Metadata(from: attributes)
        metadata.id = id
        return metadata
    }
    
}
