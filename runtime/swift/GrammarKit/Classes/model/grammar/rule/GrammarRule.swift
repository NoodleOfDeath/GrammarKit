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
        case quantifier
        case id
        case value
        case componentType
        case inverted
        case ruleClass
        case precedence
        case metadata
    }
    
    public typealias This = GrammarRule
    public typealias NodeType = GrammarRule
    
    public typealias Metadata = Grammar.Metadata
    public typealias MetadataOption = Grammar.MetadataOption
    
    override open var description: String {
        
        var strings = [String]()
        
        switch componentType {
            
        case .literal, .expression:
            strings.append(String(format: "'%@'%@", value, quantifier))
            break
            
        case .composite:
            break
            
        default:
            strings.append(String(format: "%@%@", value, quantifier))
            break
            
        }
        
        if subrules.count > 0 {
            var substrings = [String]()
            subrules.forEach { substrings.append($0.description) }
            strings.append(String(format: " (%@)%@", substrings.joined(separator: " | "), quantifier))
        }
        
        if let next = next { strings.append(String(format: " %@", next)) }
        if inverted { strings = [String(format: "~%@", strings.joined())] }
        
        return strings.joined().trimmed(true)

    }
    
    open var treeDescription: String {
        return String(format: "%@ [%@]\n\t%@\n%@", id, precedence, description, metadata)
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
    open var componentType: ComponentType
    
    /// Returns `true` if, and only if, `componentType == .composite || count > 0`.
    open var isComposite: Bool { return componentType == .composite || count > 0 }
    
    /// Returns `true` if, and only if, `componentType != .unknown`.
    open var isComponent: Bool {
        return componentType != .unknown
    }
    
    /// Indicates if this rule has an inverted prefix "~" or not.
    open var inverted: Bool = false
    
    /// Rule type of this grammar rule.
    public var ruleClass: Class = .unknown
    
    /// precedence of this grammar rule.
    open lazy var precedence = Precedence(id: id)
    
    /// Metadata of this grammar rule.
    open var metadata: Metadata = Metadata() {
        didSet { processMetadata() }
    }
    
    /// Options of this grammar rule.
    open var options: [MetadataOption] { return metadata.options }
    
    /// Category of this grammar rule.
    open var category: String? { return metadata.category }
    
    /// Categories of this grammar rule.
    open var categories: [String] { return metadata.categories }
    
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
    open var queue = [GrammarRule]()
    
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
    required public init(grammar: Grammar? = nil,
                         id: String,
                         value: String = "",
                         componentType: ComponentType = .unknown) {
        self.grammar = grammar
        self.id = id
        self.value = value
        self.componentType = componentType
    }
    
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        next = try values.decodeIfPresent(GrammarRule.self, forKey: CodingKeys.next)
        children = try values.decode([GrammarRule].self, forKey: CodingKeys.children)
        inverted = try values.decode(Bool.self, forKey: CodingKeys.inverted)
        ruleClass = try values.decode(Class.self, forKey: CodingKeys.ruleClass)
        id = try values.decode(String.self, forKey: CodingKeys.id)
        value = try values.decode(String.self, forKey: CodingKeys.value)
        quantifier = try values.decode(Quantifier.self, forKey: CodingKeys.quantifier)
        componentType = try values.decode(ComponentType.self, forKey: CodingKeys.componentType)
        metadata = try values.decode(Metadata.self, forKey: CodingKeys.metadata)
        super.init()
        precedence ?= try values.decodeIfPresent(Precedence.self, forKey: CodingKeys.precedence)
        updateChildren()
        updateNext()
        processMetadata()
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(next, forKey: .next)
        try container.encode(children, forKey: .children)
        try container.encode(quantifier, forKey: .quantifier)
        try container.encode(inverted, forKey: .inverted)
        try container.encode(ruleClass, forKey: .ruleClass)
        try container.encode(precedence, forKey: .precedence)
        try container.encode(id, forKey: .id)
        try container.encode(value, forKey: .value)
        try container.encode(componentType, forKey: .componentType)
        try container.encode(metadata, forKey: .metadata)
    }
    
    // MARK: - Static Methods
    
    public static func == (lhs: GrammarRule, rhs: GrammarRule) -> Bool {
        return (lhs.id, lhs.value) == (rhs.id, rhs.value)
    }
    
    // MARK: - Instance Methods
    
    open func consumeQueue() {
        for rule in queue { add(child: rule) }
        clearQueue()
    }
    
    open func enqueue(_ rule: GrammarRule?) {
        guard let rule = rule else { return }
        queue.append(rule)
    }
    
    open func clearQueue() {
        queue.removeAll()
    }
    
    /// Returns `true` if this grammar rule recursively references itself.
    ///
    /// - Parameters:
    ///     - ref:
    /// - Returns: `true` if this grammar rule recursively references itself.
    open func recursive(_ ref: GrammarRule? = nil) -> Bool {
        let ref = ref ?? self
        for subrule in subrules {
            if (subrule.componentType.equals(.lexerRuleReference, .lexerFragmentReference, .parserRuleReference) &&
                subrule.value == (ref.id)) || subrule.recursive(ref) {
                return true
            }
        }
        return false
    }
    
    /// Returns `true` if this grammar rule recursively references itself and
    /// would cause a potentially fatal infinite loop.
    ///
    /// - Parameters:
    ///     - ref:
    /// - Returns:
    open func recursiveFatal(_ ref: GrammarRule? = nil) -> Bool {
        if !recursive() { return false }
        let ref = ref ?? self
        var fatal = [Bool]()
        for subrule in subrules {
            fatal.append((subrule.componentType.equals(.lexerRuleReference, .lexerFragmentReference, .parserRuleReference) &&
                subrule.value == (ref.id)) || subrule.recursive(ref))
        }
        return !(fatal.count > 0 && fatal.contains(false))
    }
    
    open func processMetadata() {
        for i in 0 ..< Swift.min(subrules.count, metadata.children.count) {
            var rule: GrammarRule? = subrules[i]
            var metadata: Metadata? = self.metadata[i]
            while rule != nil, metadata != nil {
                if let rule = rule, rule.value == "COLON", rule.next?.value == "datatype" {
                    
                }
                rule?.metadata ?= metadata
                rule = rule?.next
                metadata = metadata?.next
            }
        }
    }
    
}
