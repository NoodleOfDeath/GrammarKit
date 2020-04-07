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

    /// Regular expression patterns used to parse grammar rules from string
    /// definitions.
    public struct Pattern {
        
        /// Regular expression for a `empty` grammar rule definition token.
        public static let empty = "(?:\\s*;\\s*)"
        
        /// Regular expression for a `literal` grammar rule definition token.
        public static let literal = "(?<!\\\\)'(?:\\\\'|[^'])*'(?:\\s*(?:\\.\\.)(?<!\\\\)'(?:\\\\'|[^'])*')?"
        
        /// Regular expression for a `expression` grammar rule definition token.
        public static let expression = "(?:\\s*\\^?(?:\\[.*?\\]|\\(\\?\\!.*\\)|\\.)\\$?)"
        
        /// Regular expression for a `word` grammar rule definition token.
        public static let word = "(?:[_\\p{L}]+)"
        
        /// Regular expression for a `group` grammar rule definition token.
        public static let group = "(?:\\(.*)"
        
        /// Regular expression for a `atom` grammar rule definition token.
        public static let atom = "(?:" + empty + "|" + literal +  "|" + expression + "|" + word + "|" + group + ")"
        
        /// Regular expression for a `quantifier` grammar rule definition token.
        public static let quantifier = "(?:[\\*\\+\\?]\\??|\\{\\s*\\d\\s*(?:,\\d)?\\}|\\{,\\d\\})"
        
        /// Regular expression for a `cgFragment` grammar rule definition
        /// token with capture groups.
        public static let cgFragment = "(?:fragment\\s+(\\w+))"
        
        /// Regular expression for a `cgDefinition` grammar rule definition
        /// token withcapture groups.
        public static let cgDefinition = "(.*?)(?:\\s*->\\s*([^']*))?(?:\\s*\\{(.*?)\\})?$"
        
        /// Regular expression for a `cgCommand` grammar rule definition
        /// token with capture groups.
        public static let cgCommand = "(\\w+)\\s*(?:\\((.*?)\\))?"
        
        /// Regular expression for a `cgParserAction` grammar rule definition
        /// token with capture groups.
        public static let cgParserAction = "(\\w+)\\s*(?:\\((.*?)\\))?"
        
        /// Regular expression for a `cgAlternative` grammar rule definition
        /// token with capture groups.
        public static let cgAlternative = "((?:(~)?" + atom + "\\s*" + quantifier + "?\\s*)+)"
        
        /// Regular expression for a `cgGroup` grammar rule definition token
        /// with capture groups.
        public static let cgGroup = "\\s*(\\(.*)\\s*"
        
        /// Regular expression for a `cgGreedyGroup` grammar rule definition
        /// token with capture groups.
        public static let cgGreedyGroup = "\\((.*)\\)"
        
        /// Regular expression for a `cgLiteral` grammar rule definition
        /// token with capture groups.
        public static let cgLiteral = "\\s*(?<!\\\\)'((?:\\\\'|[^'])*)'(?:\\s*(?:\\.\\.)(?<!\\\\)'((?:\\\\'|[^'])*)')?\\s*"
        
        /// Regular expression for a `cgExpression` grammar rule definition
        /// token with capture groups.
        public static let cgExpression = "(?:\\s*(" + expression + "))\\s*"
        
        /// Regular expression for a `cgAtom` grammar rule definition token with
        /// capture groups.
        public static let cgAtom = "(~)?\\s*(" + atom + ")\\s*(" + quantifier + "?)"
        
    }

}
