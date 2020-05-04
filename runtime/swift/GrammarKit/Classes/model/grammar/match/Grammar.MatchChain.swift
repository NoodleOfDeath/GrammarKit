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

extension Grammar {

    /// Data structure representing a grammar rule match tree.
    open class MatchChain: StringRange {
        
        public typealias This = Grammar.MatchChain
        public typealias NodeType = Grammar.MatchChain

        override open var description: String {
            return String(format: "%@ { %ld tokens, %ld chains } (%ld, %ld)[%ld]:\n\n%@",
                          (rule?.name ?? "unnamed"),
                          tokenCount, subchains.count, start, start + length, length,
                          subchainStrings().joined(separator: "\n"))
        }

        // MARK: - Constructors

        convenience init(rule: GrammarRule?, tokens: [Token] = []) {
            self.init()
            self.rule = rule
            add(tokens: tokens)
        }

        // MARK: - Instance Properties

        open func subchainStrings(with prefix: String = "") -> [String] {
            return subchains.enumerated().map({
                String(format: "%@ <%@> { %ld tokens, %ld chains } (%ld, %ld)[%ld]:\n%@\n%@",
                       "Subchain \(prefix)\($0.0 + 1)",
                       $0.1.rule?.name ?? "unnamed",
                       $0.1.tokenCount,
                       $0.1.subchains.count,
                       $0.1.start,
                       $0.1.end,
                       $0.1.length,
                       $0.1.tokenStrings.joined(separator: "\n"),
                       $0.1.subchainStrings(with: "\(prefix)\($0.0 + 1).").joined(separator: "\n"))
            })
        }

        open var tokenStrings: [String] {
            return tokens.enumerated().map({ "Token #\($0.0 + 1) \($0.1.descriptionWith(format: .escaped))" })
        }

        /// Parent chain of this match chain.
        open weak var parent: MatchChain?

        /// Depth of this match chain.
        open var depth: Int {
            return (parent?.depth ?? 0) + 1
        }

        /// Index of this match chain
        open var index: Int = 0

        open var indexString: String {
            guard let indexString = parent?.index else { return "\(index)" }
            return "\(indexString).\(index)"
        }

        /// Rules associated with this match chain.
        open weak var rule: GrammarRule?

        /// Leaf rule of this match chain.
        open var leafRule: GrammarRule? {
            guard subchains.count == 1 else { return nil }
            return subchains.first?.leafRule
        }

        /// Indicates whether or not this match chain matches its grammar rule.
        open var matches = false
        
        /// Indicates whether or not this match chain matches its grammar rule and
        /// contains at least one token.
        open var absoluteMatch: Bool {
            return matches && tokenCount > 0
        }
        
        /// Max range of this match chain.
        /// Shorthand for `location + length` or `range.max`.
        open var maxRange: Int {
            return start + length
        }
        
        /// Tokens collected by this match chain.
        open var tokens = [Token]()

        /// Subchains of this match chain.
        open var subchains = [MatchChain]()
        
        /// Number of tokens collected by this match chain.
        /// Alias for `tokens.count`.
        open var tokenCount: Int {
            return tokens.count
        }
        
        /// Generates a token from the string value and range of this match
        /// chain.
        open var asToken: Token {
            return Token(value: string, range: range)
        }
        
        // MARK: - Instance Methods
        
        /// Adds a token to this match chain.
        ///
        /// - Parameters:
        ///     - token: to add to this match chain.
        open func add(token: Token) {
            string += token.value
            if tokenCount == 0 { start = token.range.location }
            tokens.append(token)
            end = start + string.length
        }
        
        /// Adds a collection of tokens to this match chain.
        ///
        /// - Parameters:
        ///     - tokens: to add to this match chain.
        open func add(tokens: [Token]) {
            tokens.forEach { add(token: $0) }
        }

        open func add(subchain: MatchChain) {
            subchain.parent = self
            subchain.index = subchains.count
            subchains.append(subchain)
        }

        open func add(subchains: [MatchChain]) {
            subchains.forEach({ add(subchain: $0) })
        }

        open func has(option: Grammar.MetadataOption) -> Bool {
            return rule?.has(option: option) ?? false
        }

    }

}

