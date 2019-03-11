//
//  GrammarKit
//
//  Copyright © 2019 NoodleOfDeath. All rights reserved.
//

import Foundation

/// Data structure for a grammar rule.
@objc(GrammarRule)
open class GrammarRule: NSObject, TreeChain, Quantified, Codable {
    
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
        
        var description = ""
        
        switch componentType {
            
        case .literal, .expression:
            description += String(format: "'%@'%@", value, quantifier)
            break
            
        case .composite:
            break
            
        default:
            description += String(format: "%@%@", value, quantifier)
            break
            
        }
        
        if subrules.count > 0 {
            var strings = [String]()
            subrules.forEach { strings.append($0.description) }
            description += String(format: " (%@)%@", strings.joined(separator: " | "), quantifier)
        }
        
        if let next = next { description += String(format: " %@", next) }
        if inverted { description = String(format: "~%@", description) }
        
        return description.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    open var treeDescription: String {
        return String(format: "%@ [%@]: %@", id, precedence, description)
    }
    
    open weak var parent: NodeType?
    
    open weak var previous: NodeType?
    
    open var next: NodeType? {
        didSet { updateNext() }
    }
    
    open var children = [NodeType]() {
        didSet { updateChildren() }
    }
    
    /// Subrules of this grammar rule.
    /// Alias for `children`.
    open var subrules: [NodeType] {
        get { return children }
        set { children = newValue }
    }
    
    /// Mininum length of this rule in terms of node depth.
    open var length: Int {
        var length = 0
        if !quantifier.optional {
            for subrule in subrules {
                if length < subrule.length {
                    length = subrule.length
                }
            }
            length -= 1
        }
        return length ?+ next?.length + !quantifier.optional
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
    
    /// Returns `true` if, and only if, `componentType == .composite || childCount > 0`.
    open var isComposite: Bool { return componentType == .composite || childCount > 0 }
    
    /// Returns `true` if, and only if, `componentType != .unknown`.
    open var isComponent: Bool {
        return componentType != .unknown
    }
    
    /// Indicates if this rule has an inverted prefix "~" or not.
    open var inverted: Bool = false
    
    /// Rule type of this grammar rule.
    public var ruleClass: Class = .unknown
    
    /// precedence of this grammar rule.
    open var precedence = Precedence()
    
    /// Metadata of this grammar rule.
    open var metadata: Metadata = Metadata() {
        didSet { processMetadata() }
    }
    
    /// Options of this grammar rule.
    open var options: [MetadataOption] { return metadata.options }
    
    /// Category of this grammar rule.
    open var category: TokenCategory? { return metadata.category }
    
    /// Categories of this grammar rule.
    open var categories: [TokenCategory] { return metadata.categories }
    
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
        precedence = try values.decode(Precedence.self, forKey: CodingKeys.precedence)
        id = try values.decode(String.self, forKey: CodingKeys.id)
        value = try values.decode(String.self, forKey: CodingKeys.value)
        quantifier = try values.decode(Quantifier.self, forKey: CodingKeys.quantifier)
        componentType = try values.decode(ComponentType.self, forKey: CodingKeys.componentType)
        metadata = try values.decode(Metadata.self, forKey: CodingKeys.metadata)
        super.init()
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
        for i in 0 ..< min(subrules.count, metadata.children.count) {
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
