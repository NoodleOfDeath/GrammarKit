//
//  GrammarKit
//
//  Copyright © 2019 NoodleOfDeath. All rights reserved.
//

extension GrammarRule {

    /// Enumerated type representing the types of components that can be found
    /// in the definition of a grammar rule.
    public struct ComponentType: DefaultBaseRawRepresentable, Codable {
        
        static var defaultRawValue: String { return "unknown" }
        
        public typealias This = ComponentType
        public typealias RawValue = String
        
        public let rawValue: RawValue
        
        /// Unknown component type.
        public static let unknown = This("unknown")
        
        /// Atom component type.
        public static let atom = This("atom")
        
        /// Composite component type.
        public static let composite = This("composite")
        
        /// Expression component type.
        public static let expression = This("expression")
        
        /// Literal component type.
        public static let literal = This("literal")
        
        /// Lexer rule component type.
        public static let lexerRuleReference = This("lexerRuleReference")
        
        /// Lexer fragment component type.
        public static let lexerFragmentReference = This("lexerFragmentReference")
        
        /// Parser rule component type.
        public static let parserRuleReference = This("parserRuleReference")
        
        public init(rawValue: RawValue) {
            self.rawValue = rawValue
        }
        
    }

}
