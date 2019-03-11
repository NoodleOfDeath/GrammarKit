//
//  GrammarKit
//
//  Copyright © 2019 NoodleOfDeath. All rights reserved.
//

import Foundation
import SwiftyXMLParser

/// Base implementation of a grammar.
open class Grammar: NSObject, Codable {
    
    public typealias This = Grammar
    
    // MARK: - Static Properties
    
    public static let unmatchedRuleId = "UNMATCHED"
    public static let unmatchedRuleExpr = "."
    public static let unmatchedRuleOrder = Int.min
    
    // MARK: - CustomStringConvertible Properties
    
    open override var description: String {
        return ""
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
    open lazy var unmatchedRule: GrammarRule = {
        let rule = GrammarRule(grammar: self, id: This.unmatchedRuleId, value: This.unmatchedRuleExpr, componentType: .literal)
        rule.ruleClass = .lexerRule
        rule.precedence = GrammarRule.Precedence(id: This.unmatchedRuleId, This.unmatchedRuleOrder)
        return rule
    }()
    
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
        lexerRules.sort { $0.precedence > $1.precedence }
        parserRules.sort { $0.precedence > $1.precedence }
    }
    
    /// Adds a built-in identifier to this grammar.
    ///
    /// - Parameters:
    ///     - identifier: to add to this grammar.
    open func add(identifier: Identifier) {
        identifiers.append(identifier)
    }
    
}
