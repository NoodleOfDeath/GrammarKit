//
//  GrammarKit
//
//  Copyright © 2019 NoodleOfDeath. All rights reserved.
//

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
