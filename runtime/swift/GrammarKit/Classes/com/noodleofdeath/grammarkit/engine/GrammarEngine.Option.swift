//
//  GrammarEngine.Option.swift
//  GrammarKit
//
//  Created by MORGAN, THOMAS B on 2/21/19.
//

import Foundation

extension GrammarEngine {
    
    ///
    public struct Option: BaseOptionSet {
        
        public typealias This = Option
        public typealias RawValue = Int
        
        public let rawValue: RawValue
        
        ///
        public static let verbose = This(1 << 0)
        
        public init(rawValue: RawValue) {
            self.rawValue = rawValue
        }
        
    }
    
}
