//
//  PastaParser
//
//  Copyright © 2019 NoodleOfDeath. All rights reserved.
//

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
