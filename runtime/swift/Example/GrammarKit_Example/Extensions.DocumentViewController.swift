//
//  Extensions.DocumentViewController.swift
//  WorqFlo
//
//  Created by MORGAN, THOMAS B on 3/8/19.
//  Copyright © 2019 com.noodleofdeath. All rights reserved.
//

import SwiftyFileExplorer
import PastaParser

typealias ColorScheme = DocumentViewController.ColorScheme

extension ColorScheme {
    
    typealias TC = TokenCategory
    
    static let `default`: ColorScheme = {
        var textStyles = [String: TextStyle]()
        textStyles[TC.comment] =
            [.foregroundColor: UIColor(0x009900),]
        textStyles[TC.constructor] =
            [.foregroundColor: UIColor(0xff0000),]
        textStyles[TC.datatype] =
            [.foregroundColor: UIColor(0xff0000),]
        textStyles[TC.documentation] =
            [.foregroundColor: UIColor.magenta,]
        textStyles[TC.identifier] =
            [.foregroundColor: UIColor.orange,]
        textStyles[TC.method] =
            [.foregroundColor: UIColor(0xff6666),]
        textStyles[TC.number] =
            [.foregroundColor: UIColor(0x00cc00),]
        textStyles[TC.string] =
            [.foregroundColor: UIColor.magenta,]
        return ColorScheme(textStyles: textStyles)
    }()
    
}
