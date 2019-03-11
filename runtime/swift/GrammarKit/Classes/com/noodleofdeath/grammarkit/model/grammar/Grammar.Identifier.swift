//
//  PastaParser
//
//  Copyright © 2019 NoodleOfDeath. All rights reserved.
//

import UIKit

extension Grammar {

    /// Data structure that represents an identifier found in a grammar
    /// that can be indexed.
    @objc(GrammarIdentifier)
    open class Identifier: URLTextRange {
        
        public typealias This = Identifier
        
        public enum CodingKeys: String, CodingKey {
            case url
            case string
            case type
            case detailedDescription
            case metadata
        }
        
        override open var description: String {
            return String(describing: string)
        }
        
        // MARK: - Instance Properties
        
        /// Summary of this identifier.
        open var detailedDescription: String?
        
        /// Type of this identifier
        open var type: String?
        
        /// Type of this identifier
        open lazy var metadata: Metadata = Metadata()
        
        // MARK: - Constructor Methods
        
        /// Constructs a new identifer.
        public convenience init(url: URL? = nil, start: Int? = nil, string: String, type: String? = nil, detailedDescription: String? = nil, metadata: Metadata? = nil) {
            self.init(start: start ?? 0, length: string.length, string: string)
            self.url = url
            self.type = type
            self.detailedDescription = detailedDescription
            self.metadata = metadata ?? Metadata()
        }
        
    }

}

extension Grammar.Identifier: Comparable {
    
    public static func < (lhs: This, rhs: This) -> Bool {
        return lhs.string < rhs.string
    }
    
    public static func == (lhs: This, rhs: This) -> Bool {
        return
            lhs.url == rhs.url &&
            (lhs.start, lhs.end) == (rhs.start, rhs.end)
    }
    
}
