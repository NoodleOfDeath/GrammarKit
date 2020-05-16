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

/// Data structure for a grammar rule.
open class GrammarRule: NSObject, TreeChain, Quantifiable, ComparisonGraphNode, Codable {
    
    enum CodingKeys: String, CodingKey {
        case next
        case children
        case inverted
        case type
        case id
        case value
        case quantifier
        case metadata
        case precedence
    }
    
    public typealias This = GrammarRule
    public typealias NodeType = GrammarRule
    
    public typealias Metadata = Grammar.Metadata
    public typealias MetadataOption = Grammar.MetadataOption

    override open var description: String {
        return String(format: "%@ %@ [%@]\n\tDefinition: %@\n%@",
                      id, String(describing: type), precedence,
                      definition, metadata)
    }

    // MARK: - Node Properties
    
    open weak var parent: NodeType?

    // MARK: - Tree Properties

    open var children = [NodeType]() {
        didSet { updateChildren() }
    }

    /// Subrules of this grammar rule.
    /// Alias for `children`.
    open var subrules: [NodeType] {
        get { return children }
        set { children = newValue }
    }

    // MARK: - NodeChain Properties
    
    open weak var previous: NodeType?
    
    open var next: NodeType? {
        didSet { updateNext() }
    }

    // MARK: - Instance Properties

    open var isEmpty: Bool { return value.length == 0 || count == 0 }

     open var definition: String {

        var strings = [String]()

        switch type {

        case .literal, .expression:
            strings.append(String(format: "'%@'%@", value, quantifier))

        case .composite, .lexerRule, .parserRule:
            break

        case .captureGroupReference:
            strings.append(String(format: "%%%@%@", value, quantifier))

        default:
            strings.append(String(format: "%@%@", value, quantifier))

        }

        if subrules.count > 0 {
            var substrings = [String]()
            subrules.forEach { substrings.append($0.definition) }
            strings.append(String(format: " (%@%@)%@", groupName != nil ? "?<\(groupName!)> " : "", substrings.joined(separator: " | "), quantifier))
        }

        if let next = next { strings.append(String(format: " %@", next.definition)) }
        if inverted { strings = [String(format: "~%@", strings.joined())] }

        return strings.joined()

    }

    open var derivedId: String {
        let localId = (isRoot ? id : isRuleReference ? value : groupName ?? String(depth - 1))
        guard let prefix = parent?.derivedId else { return (inverted ? "~" : "") + localId }
        return (inverted ? "~" : "") + prefix + "." + localId
    }

    open var groupName: String?

    /// Mininum length of this rule in terms of node depth.
    open var minLength: Int {
        var length = 0
        if !quantifier.optional {
            for subrule in subrules {
                if length < subrule.minLength {
                    length = subrule.minLength
                }
            }
            length -= 1
        }
        return length + (next?.minLength ?? 0) + !quantifier.optional
    }
    
    open var quantifier: Quantifier = .once
    
    /// Grammar of this grammar rule.
    open weak var grammar: Grammar?
    
    /// Id of this grammar rule.
    public let id: String
    
    /// Value of this grammar rule.
    public let value: String
    
    /// Component type of this grammar rule.
    open var type: RuleType

    open var isValid: Bool { return type.isValid }

    /// Returns `true` if, and only if, `type.isRule == true`.
    open var isRule: Bool { return type.isRule }

    /// Returns `true` if, and only if, `type.isRuleReference == true`.
    open var isRuleReference: Bool { return type.isRuleReference }

    /// Returns `true` if, and only if, `type.isSubrule == true`.
    open var isSubrule: Bool { return type.isSubrule || parent != nil }

    /// `true` if `type == .lexerRule`.
    open var isLexerRule: Bool { return type.isLexerRule }

    /// `true` if `type == .parserRule`.
    open var isParserRule: Bool { return type.isParserRule }

    /// Returns `true` if, and only if, `has(option: .fragment) == true`; `false`, otherwise.
    open var isFragment: Bool { return has(option: .fragment) }
    
    /// Returns `true` if, and only if, `type == .composite || count > 0`.
    open var isComposite: Bool { return type == .composite || count > 0 }
    
    /// Indicates if this rule has an inverted prefix "~" or not.
    open var inverted: Bool = false
    
    /// precedence of this grammar rule.
    open lazy var precedence = Precedence(id: id)
    
    /// Metadata of this grammar rule.
    open var metadata: Metadata = Metadata()
    
    /// Options of this grammar rule.
    open var options: [MetadataOption] { return metadata.options }

    /// Options of this grammar rule.
    open var groups: [String: Metadata] { return metadata.groups }
    
    /// Returns `true` if, and only if, `options` contains `option`.
    ///
    /// - Parameters:
    ///     - option: Option to test.
    /// - Returns: `true` if, and only if, `options` contains `option`.
    open func has(option: MetadataOption) -> Bool {
        return metadata.has(option: option)
    }
    
    /// Returns `true` if, and only if, `options` contains `option`.
    ///
    /// - Parameters:
    ///     - option: Option to test.
    /// - Returns: `true` if, and only if, `options` contains `option`.
    open func has(option: MetadataOption.RawValue) -> Bool {
        return metadata.has(option: option)
    }
    
    ///
    open var queue = [NodeType]()
    
    // MARK: - Constructor Methods
    
    /// Constructs a new grammar rule with an initial id, value, type, and
    /// parent grammar.
    ///
    /// - Parameters:
    ///     - grammar: of this new rule.
    ///     - rootAncestor:
    ///     - id: of this new rule.
    ///     - value: of this new rule.
    ///     - type: of this new rule.
    required public init(grammar: Grammar? = nil, id: String, value: String = "", type: RuleType = .none) {
        self.grammar = grammar
        self.id = id
        self.value = value
        self.type = type
    }

    // MARK: - Decodable Constructor Methods
    
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        next = try values.decodeIfPresent(GrammarRule.self, forKey: .next)
        children = try values.decode([GrammarRule].self, forKey: .children)
        inverted = try values.decode(Bool.self, forKey: .inverted)
        type = try values.decode(RuleType.self, forKey: .type)
        id = try values.decode(String.self, forKey: .id)
        value = try values.decode(String.self, forKey: .value)
        quantifier = try values.decode(Quantifier.self, forKey: .quantifier)
        metadata = try values.decode(Metadata.self, forKey: .metadata)
        super.init()
        precedence ?= try values.decodeIfPresent(Precedence.self, forKey: .precedence)
        updateChildren()
        updateNext()
    }

    // MARK: - Static Methods

    public static func == (lhs: GrammarRule, rhs: GrammarRule) -> Bool {
        return (lhs.id, lhs.value) == (rhs.id, rhs.value)
    }

    // MARK: - Encodable Methods

    open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(next, forKey: .next)
        try container.encode(children, forKey: .children)
        try container.encode(quantifier, forKey: .quantifier)
        try container.encode(inverted, forKey: .inverted)
        try container.encode(type, forKey: .type)
        try container.encode(id, forKey: .id)
        try container.encode(value, forKey: .value)
        try container.encode(metadata, forKey: .metadata)
        try container.encode(precedence, forKey: .precedence)
    }
    
    // MARK: - Instance Methods
    
    open func consumeQueue() {
        for rule in queue { add(child: rule) }
        clearQueue()
    }
    
    open func enqueue(_ rule: NodeType?) {
        guard let rule = rule else { return }
        queue.append(rule)
    }
    
    open func clearQueue() {
        queue.removeAll()
    }
    
    /// Returns `true` if this grammar rule recursively references itself;
    /// `false`, othwerwise.
    ///
    /// - Parameters:
    ///     - ref:
    /// - Returns: `true` if this grammar rule recursively references itself;
    /// `false`, othwerwise.
    open func recursive(_ reference: NodeType? = nil) -> Bool {
        let reference = reference ?? self
        for subrule in subrules {
            if (subrule.isRuleReference && subrule.value == (reference.id)) || subrule.recursive(reference) {
                return true
            }
        }
        return false
    }
    
    /// Returns `true` if this grammar rule recursively references itself and
    /// would cause a potentially reference infinite loop; `false`, otherwise.
    ///
    /// - Parameters:
    ///     - reference: that could be
    /// - Returns: `true` if this grammar rule recursively references itself and
    /// would cause a potentially reference infinite loop; `false`, otherwise.
    open func infinitelyRecursive(_ reference: NodeType? = nil) -> Bool {
        if !recursive() { return false }
        let reference = reference ?? self
        var isInfinite = [Bool]()
        for subrule in subrules {
            if subrule.infinitelyRecursive(reference) { return true }
            isInfinite.append((subrule.isRuleReference && subrule.value == (reference.id)) || subrule.recursive(reference))
        }
        guard isInfinite.count > 0 else { return false }
        return !isInfinite.contains(false)
    }
    
}
