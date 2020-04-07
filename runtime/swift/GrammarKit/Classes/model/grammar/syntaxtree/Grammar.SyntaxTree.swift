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

import UIKit

extension Grammar {

    /// Data structure representing a grammar rule match tree.
    open class SyntaxTree: StringRange, TreeChain {
        
        public typealias This = Grammar.SyntaxTree
        public typealias NodeType = Grammar.SyntaxTree
        
        /// Enumerated type for the two types of syntax tree
        /// classes: lexer tree, parser tree, and unknown.
        public enum Class: Int, Codable {
            
            /// Unknown syntax tree class.
            case unknown
            
            /// Lexer tree class.
            case lexerTree
            
            /// Parser tree class.
            case parserTree
            
            /// `true` if `self == .unknown`.
            public var isUnknown: Bool {
                return self == .unknown
            }
            
            /// `true` if `self == .lexerTree`.
            public var isLexerTree: Bool {
                return self == .lexerTree
            }
            
            /// `true` if `self == .parserTree`.
            public var isParserTree: Bool {
                return self == .parserTree
            }
            
        }
        
        override open var description: String {
            return String(format: "%@: [%@] { %ld token(s) } (%ld, %ld)[%ld]",
                          rule?.id ?? "No Match",
                          treeClass.isLexerTree ? string.format(using: .escaped) :
                            (treeClass.isParserTree ? tokens.description : string),
                          count, start, start + length, length)
        }
        
        open var treeDescription: String {
            return description
        }

        // MARK: Node Properties
        
        open var parent: NodeType?

        // MARK: - Tree Properties
        
        open var previous: NodeType?
        
        open var next: NodeType?
        
        open var children = [NodeType]()
        
        // MARK: - Instance Properties
        
        /// Grammar rule associated with this syntax tree.
        open var rule: GrammarRule?
        
        /// Tree class of this syntax tree.
        public var treeClass: Class = .lexerTree
        
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
            return start + length
        }
        
        /// Returns the range of this syntax tree after omitting its first and
        /// last tokens.
        open var innerRange: NSRange {
            return NSMakeRange(start + 1, length - 2)
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
        ///     - treeClass: of the new syntax tree.
        public convenience init(treeClass: Class) {
            self.init()
            self.treeClass = treeClass
        }
        
        // MARK: - Instance Methods
        
        /// Adds a token to this syntax tree.
        ///
        /// - Parameters:
        ///     - token: to add to this syntax tree.
        open func add(token: Token) {
            string += token.value
            if count == 0 { start = token.range.location }
            tokens.append(token)
            end = start + string.length
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

}
