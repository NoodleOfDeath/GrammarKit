//
//  PastaParser
//
//  Copyright © 2019 NoodleOfDeath. All rights reserved.
//

import Foundation

/// Simple data structure representing a token read by a lexer grammar engine.
@objc
open class Token: NSObject, Codable {
    
    // MARK: - Static Properties

    /// Generates a token with no rule or value and a zero range.
    open class var zero: Token {
        return Token(value: "", range: NSMakeRange(0, 0))
    }
    
    // MARK: - CustomStringConvertible Properties
    
    override open var description: String {
        return String(format: "%@: \"%@\" (%d, %d)[%d]",
                      rule?.id ?? "",
                      value,
                      range.location,
                      range.max,
                      range.length)
    }
    
    // MARK: - Instance Properties

    /// Grammar rule of this token.
    open weak var rule: GrammarRule?

    /// String value of this token.
    public let value: String
    
    /// Range of this token.
    public let range: NSRange
    
    /// Metadata of this token.
    public var metadata: Grammar.Metadata?
    
    // MARK: - Constructor Methods
    
    /// Constructs a new token instance with an initial rule, value, and range.
    ///
    /// - Parameters:
    ///     - rule: of the new token.
    ///     - value: of the new token.
    ///     - range: of the new token.
    public init(rule: GrammarRule? = nil, value: String, range: NSRange) {
        self.rule = rule
        self.value = value
        self.range = range
    }
    
    /// Constructs a new token instance with an initial rul, value, start,
    /// and length.
    ///
    /// Alias for `.init(rule: rule, value: value,
    /// range: NSMakeRange(start, length))`
    ///
    /// - Parameters:
    ///     - rule: of the new token.
    ///     - value: of the new token.
    ///     - start: of the new token.
    ///     - length: of the new token.
    public convenience init(rule: GrammarRule? = nil, value: String, start: Int, length: Int) {
        self.init(rule: rule, value: value, range: NSMakeRange(start, length))
    }
    
}
