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
    
    /// Enumerated type for the two types of grammar rule
    /// classes: lexer rule, parser rule, and unknown.
    public enum Class: Int, Codable {
        
        /// Unknown grammar rule class.
        case unknown
        
        /// Lexer rule class.
        case lexerRule
        
        /// Parser Rule class.
        case parserRule

        /// `true` if `self == .unknown`.
        public var isUnknown: Bool {
            return self == .unknown
        }
        
        /// `true` if `self == .lexerRule`.
        public var isLexerRule: Bool {
            return self == .lexerRule
        }
        
        /// `true` if `self == .parserRule`.
        public var isParserRule: Bool {
            return self == .parserRule
        }
        
    }
    
}
