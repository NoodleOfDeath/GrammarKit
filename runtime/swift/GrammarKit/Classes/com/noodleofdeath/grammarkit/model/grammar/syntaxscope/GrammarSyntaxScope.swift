//
//  PastaParser
//
//  Copyright © 2019 NoodleOfDeath. All rights reserved.
//

import UIKit

/// Data structure representing a grammar rule match tree.
@objc
open class GrammarSyntaxScope: CountableTextRange, TreeChain {
    
    public typealias This = GrammarSyntaxScope
    public typealias NodeType = GrammarSyntaxScope
    
    override open var description: String {
        return String(format: "%@: [%@] { %ld token(s) } (%ld, %ld)[%ld]",
                      rule?.id ?? "No Match",
                      scopeClass.isLexerScope ? string.format(using: .escaped) :
                        (scopeClass.isParserScope ? tokens.description : string),
                      count, start.location, start.location + length, length)
    }
    
    open var treeDescription: String {
        return description
    }
    
    open var rootAncestor: NodeType?
    
    open var parent: NodeType?
    
    open var previous: NodeType?
    
    open var next: NodeType?
    
    open var children = [NodeType]()
    
    /// Grammar rule associated with this syntax tree.
    open var rule: GrammarRule?
    
    /// Tree class of this syntax tree.
    public var scopeClass: Class = .lexerScope
    
    /// Indicates whether or not this syntax tree matches its grammar rule.
    open var matches = false
    
    /// Indicates whether or not this syntax tree matches its grammar rule and
    /// contains at least one token.
    open var absoluteMatch: Bool {
        return matches && count > 0
    }
    
    /// Max range of this syntax tree.
    /// Shorthand for `location + length` or `range.max`.
    open var maxRange: Int {
        return start.location + length
    }
    
    /// Returns the range of this syntax tree after omitting its first and
    /// last tokens.
    open var innerRange: NSRange {
        return NSMakeRange(start.location + 1, length - 2)
    }
    
    /// Tokens collected by this syntax tree.
    open var tokens = [Token]()
    
    /// Number of tokens collected by this syntax tree.
    /// Alias for `tokens.count`.
    open var count: Int {
        return tokens.count
    }
    
    /// Generates a token from the value and range of this syntax tree.
    open var generatedToken: Token {
        return Token(value: string, range: range)
    }
    
    // MARK: - Constructor Methods
    
    /// Constructs a new syntax tree of a particular tree class.
    ///
    /// - Parameters:
    ///     - scopeClass: of the new syntax tree.
    public convenience init(scopeClass: Class) {
        self.init()
        self.scopeClass = scopeClass
    }
    
    // MARK: - Instance Methods
    
    /// Adds a token to this syntax tree.
    ///
    /// - Parameters:
    ///     - token: to add to this syntax tree.
    open func add(token: Token) {
        string += token.value
        if count == 0 { set(start: token.range.location) }
        tokens.append(token)
        set(length: string.length)
    }
    
    /// Adds a collection of tokens to this syntax tree.
    ///
    /// - Parameters:
    ///     - tokens: to add to this syntax tree.
    open func add(tokens: [Token]) {
        tokens.forEach { add(token: $0) }
    }
    
    /// Clears the value of this syntax tree and empties all of its tokens.
    open func clear() {
        string = ""
        tokens = []
    }

}

