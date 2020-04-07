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

/// Simple data structure representing a token read by a lexer grammar engine.
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
