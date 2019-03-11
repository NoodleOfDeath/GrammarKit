//
//  GrammarKit
//
//  Copyright © 2019 NoodleOfDeath. All rights reserved.
//

extension GrammarSyntaxScope {
    
    /// Enumerated type for the two types of syntax tree
    /// classes: lexer tree, parser tree, and unknown.
    public enum Class: Int, Codable {
        
        /// Unknown syntax tree class.
        case unknown
        
        /// Lexer tree class.
        case lexerScope
        
        /// Parser tree class.
        case parserScope
        
        /// `true` if `self == .unknown`.
        public var isUnknown: Bool {
            return self == .unknown
        }
        
        /// `true` if `self == .lexerScope`.
        public var isLexerScope: Bool {
            return self == .lexerScope
        }
        
        /// `true` if `self == .parserScope`.
        public var isParserScope: Bool {
            return self == .parserScope
        }
        
    }
    
}
