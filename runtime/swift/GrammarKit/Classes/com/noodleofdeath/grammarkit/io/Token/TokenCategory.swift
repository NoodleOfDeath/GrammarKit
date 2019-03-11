//
//  PastaParser
//
//  Copyright © 2019 NoodleOfDeath. All rights reserved.
//

import Foundation

public enum TokenCategory: String, RawRepresentable, Codable {
    
    case comment
    case constructor
    case datatype
    case declaration
    case documentation
    case identifier = "id"
    case keyword
    case method
    case number
    case string
    case type
    
}
