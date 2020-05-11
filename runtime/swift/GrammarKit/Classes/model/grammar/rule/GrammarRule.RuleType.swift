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

extension GrammarRule {

    /// Enumerated type representing the types of components that can be found
    /// in the definition of a grammar rule.
    public enum RuleType: Int, Codable {
        
        /// No subrule type.
        case none

        /// Lexer rule type.
        case lexerRule

        /// Parser rule type.
        case parserRule
        
        /// Atom subrule type.
        case atom
        
        /// Composite subrule type.
        case composite
        
        /// Expression subrule type.
        case expression
        
        /// Literal subrule type.
        case literal
        
        /// Lexer rule subrule type.
        case lexerRuleReference
        
        /// Parser rule subrule type.
        case parserRuleReference

        /// Capture group rule reference.
        case captureGroupReference

        /// `true` if `self == .lexerRule`.
        public var isLexerRule: Bool { return self == .lexerRule }

        /// `true` if `self == .parserRule`.
        public var isParserRule: Bool { return self == .parserRule }

        /// Returns `true` if, and only if, `self != .none`; `false`, otherwise.
        public var isValid: Bool { return self != .none }

        /// Returns `true` if, and only if, `isLexerRule || isParserRule == true`; `false`, otherwise.
        public var isRule: Bool { return isLexerRule || isParserRule }

        /// Returns `true` if, and only if, `self == .lexerRuleReference || self == .parserRuleReference`; `false`, otherwise.
        public var isRuleReference: Bool { return self == .lexerRuleReference || self == .parserRuleReference }

        /// Returns `true` if, and only if, `isValid && !isRule == true`; `false`, otherwise.
        public var isSubrule: Bool { return isValid && !isRule }
        
    }

}
