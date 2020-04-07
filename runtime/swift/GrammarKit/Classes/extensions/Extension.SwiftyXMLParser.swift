//
//  Extension.SwiftyXMLParser.swift
//  WorqFlo
//
//  Created by MORGAN, THOMAS B on 5/16/19.
//  Copyright © 2020 NoodleOfDeath. All rights reserved.
//

import Foundation

import SwiftyXMLParser

extension XML.Accessor {
    
    subscript <RawRepresentableType: RawRepresentable>(key: RawRepresentableType) -> XML.Accessor where RawRepresentableType.RawValue == String {
        return self[key.rawValue]
    }
    
    subscript <RawRepresentableType: RawRepresentable>(keys: [RawRepresentableType]) -> XML.Accessor where RawRepresentableType.RawValue == String {
        return self[keys.map { $0.rawValue}]
    }
    
}
