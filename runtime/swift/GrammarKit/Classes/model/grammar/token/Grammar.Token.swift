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

    /// Simple data structure representing a token read by a lexer grammatical scanner.
    open class Token: IO.Token {

        enum CodingKeys: String, CodingKey {
            case rules
        }

        // MARK: - CustomStringConvertible Properties

        override open var description: String {
            return String(format: "%@ (%d, %d)[%d]: \"%@\"",
                          rules.keys.joined(separator: "/"),
                          range.location,
                          range.max,
                          range.length,
                          value)
        }

        open func descriptionWith(format: StringFormattingOption) -> String {
            return String(format: "%@ (%d, %d)[%d]: \"%@\" ",
                            rules.keys.joined(separator: "/"),
                            range.location,
                            range.max,
                            range.length,
                            value.format(using: format))
        }

        // MARK: - Instance Properties

        /// Rules associated with this token.
        open var rules = [String: GrammarRule]()

        // MARK: - Constructor Methods

        /// Constructs a new token instance with an initial rule, value, and range.
        ///
        /// - Parameters:
        ///     - value: of the new token.
        ///     - range: of the new token.
        ///     - rules: of the new token.
        public init(value: String, range: NSRange, rules: [GrammarRule] = []) {
            super.init(value: value, range: range)
            add(rules: rules)
        }

        /// Constructs a new token instance with an initial rul, value, start,
        /// and length.
        ///
        /// Alias for `.init(rule: rule, value: value,
        /// range: NSMakeRange(start, length))`
        ///
        /// - Parameters:
        ///     - rules: of the new token.
        ///     - value: of the new token.
        ///     - start: of the new token.
        ///     - length: of the new token.
        public convenience init(value: String, start: Int, length: Int, rules: [GrammarRule] = []) {
            self.init(value: value, range: NSMakeRange(start, length), rules: rules)
        }

        // MARK: - Decodable Constructor Methods

       public required init(from decoder: Decoder) throws {
            try super.init(from: decoder)
            let values = try decoder.container(keyedBy: CodingKeys.self)
            rules = try values.decode([String: GrammarRule].self, forKey: .rules)
        }

        // MARK: - Encodable Methods

        open func encode(with encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(rules, forKey: .rules)
        }

        // MARK: - Instance Methods

        open func add(rule: GrammarRule) {
            rules[rule.id] = rule
        }

        open func add(rules: [GrammarRule]) {
            rules.forEach({ add(rule: $0 )})
        }

        open func matches(_ rule: GrammarRule) -> Bool {
            return matches(rule.id)
        }

        open func matches(_ id: String) -> Bool {
            return rules.keys.contains(id)
        }

    }

}

extension IO.TokenStream where Atom: Grammar.Token {

    open func reduce(over range: Range<Int>) -> String {
        return reduce(over: range, "", { (a, b) -> String in
            "\(a)\(b.value)"
        })
    }

    open func reduce(over range: NSRange) -> String {
        return reduce(over: range.bridgedRange)
    }

}
