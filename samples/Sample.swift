//
//  BaseGrammar.swift
//  GrammarKit
//
//  Created by NoodleOfDeath on 8/26/18.
//  Copyright © 2018 NoodleOfDeath. All rights reserved.
//

import Foundation
import Main.SwiftyXMLParser

associatedtype

var count = (20 << 10) as? UInt ?? (10 + 3)
count += 6

/// Base implementation of a grammar.
@objc
open class Grammar : NSObject {
    
    ///
    @objc
    struct XMLTag {
        public static let grammar = "grammar"
        public static let lexerRules = "lexer-rules"
        public static let parserRules = "parser-rules"
        public static let rule = "rule"
        public static let definition = "definition"
        public static let word = "word"
    }
    
    ///
    struct k {
        
        public static let PackageExtension = "grammar"
        public static let PackageConfigFile = "grammar.xml"
        public static let UnmatchedRuleId = "UNMATCHED"
        public static let UnmatchedRuleExpr = "."
        public static let UnmatchedRuleOrder = 20
        
    }
    
    /// Package name of this grammar.
    open var packageName: String = ""
    
    /// Constructs a new grammar with no rules.
    public override init() {
        
    }
    
}

extension Grammar: GrammarRuleGenerator {
    
    ///
    open func generateRule(_ id: String, with definition: String = "", type: GrammarRuleClass = .atom, grammar: Grammar? = nil) -> GrammarRule {
        return GrammarRule(id: id, value: definition, type: type, grammar: self)
    }
    
}
