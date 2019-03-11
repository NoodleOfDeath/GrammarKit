//
//  PastaParser
//
//  Copyright © 2019 NoodleOfDeath. All rights reserved.
//

import Foundation

extension Grammar {
    
    /// Common grammar rule options represented as an enumerated string type.
    public struct MetadataOption: BaseRawRepresentable, Codable {
        
        public typealias This = MetadataOption
        public typealias RawValue = String
        
        public let rawValue: RawValue
        
        /// Indicates that this rule should not be added to the
        /// rule map of enumerated rules of this container grammar.
        public static let omit = This("omit")
        
        /// Indicates that the lexer/parser should skip notifiying
        /// observers when this rule encounters matches.
        public static let skip = This("skip")
        
        /// Indicates that the rule can span over multiple lines.
        public static let multiline = This("multiline")
        
        /// Indicates that the rule contains nested scopes that
        /// were not scanned.
        public static let nested = This("nested")
        
        /// Indicates that the rule should be catalogged by the IDE.
        public static let index = This("index")
        
        /// Indicates that the rule contains the identifier to an imported
        /// file reference.
        public static let `import` = This("import")
        
        public init(rawValue: RawValue) {
            self.rawValue = rawValue
        }
        
        public init?(_ rawValue: RawValue?) {
            guard let rawValue = rawValue else { return nil }
            self.init(rawValue: rawValue)
        }
        
        public init?(rawValue: RawValue?) {
            guard let rawValue = rawValue else { return nil }
            self.init(rawValue: rawValue)
        }
        
        public static func == (lhs: This, rhs: This) -> Bool {
            return lhs.rawValue.lowercased() == rhs.rawValue.lowercased()
        }
        
    }
    
}
