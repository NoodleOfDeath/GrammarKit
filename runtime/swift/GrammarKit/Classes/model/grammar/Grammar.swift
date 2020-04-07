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
import SwiftyXMLParser

/// Base implementation of a grammar.
open class Grammar: NSObject, Codable {
    
    public typealias This = Grammar
    
    // MARK: - Static Properties
    
    public static let unmatchedRuleId = "UNMATCHED"
    public static let unmatchedRuleExpr = "."
    public static let unmatchedRuleOrder = "min"
    
    // MARK: - CustomStringConvertible Properties
    
    open override var description: String {
        var strings = [String]()
        strings.append("")
        strings.append(String(format: "--- Lexer Rules (%d) ---", lexerRules.count))
        strings.append("")
        for rule in lexerRules {
            strings.append(rule.treeDescription)
        }
        strings.append("")
        strings.append(String(format: "--- Parser Rules (%d) ---", parserRules.count))
        strings.append("")
        for rule in parserRules {
            strings.append(rule.treeDescription)
        }
        strings.append("")
        return strings.joined(separator: "\n")
    }
    
    // MARK: - Instance Properties
    
    /// Package name of this grammar.
    open var packageName: String = ""
    
    /// Name of this grammar.
    open var name: String = ""

    /// Rule map of this grammar.
    open var rules = [String: GrammarRule]() {
        didSet { deriveRuleSets() }
    }
    
    /// Lexer rules of this grammar.
    open lazy var lexerRules: [GrammarRule] = [GrammarRule]()
    
    /// Parser rules of this grammar.
    open lazy var parserRules: [GrammarRule] = [GrammarRule]()
    
    /// Identifiers of this grammar.
    open var identifiers = [Identifier]()
    
    /// Unmatched rule of this grammar. Used only for lexer grammars.
    open var unmatchedRule: GrammarRule {
        let rule = GrammarRule(grammar: self, id: This.unmatchedRuleId, value: This.unmatchedRuleExpr, componentType: .literal)
        rule.ruleClass = .lexerRule
        rule.precedence = GrammarRule.Precedence(id: This.unmatchedRuleId, This.unmatchedRuleOrder)
        return rule
    }
    
    /// Words of this grammar.
    open var words = [Identifier]()
    
    // MARK: - Constructor Methods
    
    /// Constructs a new grammar with an initial map of rules and words.
    ///
    /// - Parameters:
    ///     - rules: of the new grammar.
    ///     - words: of the new grammar.
    public required init(rules: [String: GrammarRule]? = nil, words: [Identifier]? = nil) {
        super.init()
        self.rules = rules ?? [:]
        self.words = words ?? []
        deriveRuleSets()
    }
    
    public required convenience init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let rules = try values.decode([String: GrammarRule].self, forKey: .rules)
        let words = try values.decode([Identifier].self, forKey: .identifiers)
        self.init(rules: rules, words: words)
    }
    
    // MARK: - Instance Methods
    
    /// Retrieves the grammar rule associated with the specified id, if one
    /// exists.
    ///
    /// - Parameters:
    ///     - id: of the grammar rule to retrieve.
    /// - Returns: grammar rule assocaited with the specified id, if one exists.
    open subscript (id: String) -> GrammarRule? {
        get { return rules[id] }
        set { rules[id] = newValue }
    }
    
    /// Derives the lexer rules and parser rules of this grammar from the
    /// `rules` map.
    open func deriveRuleSets() {
        let flatMap = rules.map { $1 }
        lexerRules = flatMap.filter { !$0.has(option: .omit) && $0.ruleClass == .lexerRule }
        parserRules = flatMap.filter { !$0.has(option: .omit) && $0.ruleClass == .parserRule }
        sortRules()
    }
    
    /// Sorts the rule map of this grammar.
    open func sortRules() {
        lexerRules = sort(rules: lexerRules)
        parserRules = sort(rules: parserRules)
    }

    fileprivate func sort(rules: [GrammarRule]) -> [GrammarRule] {
        let graph = ComparisonGraph(nodes: rules)
        // Load weighted rules first.
        for rule in rules.sorted(by: { $0.precedence.weight != nil && $1.precedence.weight == nil })  {
            if let weight = rule.precedence.weight {
                graph.set(weight: weight, for: rule.id)
            }
            rule.precedence.relations.forEach {
                graph.connect(rule.id, $0, $1)
            }
        }
        graph.resolveEqualRelations()
        for rule in rules {
            if rule.precedence.weight == nil, let weight = graph.weights[rule.id] {
                rule.precedence.weight = weight
            }
            if let relations = graph.relations[rule.id] {
                rule.precedence.relations = relations
            }
        }
        return graph.sorted(reversed: true)
    }
    
    /// Adds a built-in identifier to this grammar.
    ///
    /// - Parameters:
    ///     - identifier: to add to this grammar.
    open func add(identifier: Identifier) {
        identifiers.append(identifier)
    }
    
}
