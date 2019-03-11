//
//  GrammarKit
//
//  Copyright © 2019 NoodleOfDeath. All rights reserved.
//

extension GrammarLoader {
    
    /// OptionSet 0 representing the different options that can be used
    /// when loading a grammar.
    public struct Option: OptionSet {
        
        public typealias This = Option
        public typealias RawValue = UInt
        
        public let rawValue: RawValue
        
        /// Indicates that the grammar should be loaded verbosely, printing
        /// debug related information to the standard output.
        public static let verbose = This(1 << 0)
        
        public init(_ rawValue: RawValue) {
            self.rawValue = rawValue
        }
        
        public init(rawValue: RawValue) {
            self.rawValue = rawValue
        }
        
    }
    
}
