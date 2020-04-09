//
//  GrammarKit
//
//  Copyright © 2020 NoodleOfDeath. All rights reserved.
//

import XCTest

import SwiftyUTType
import GrammarKit

class Tests: XCTestCase {
    
    func testExample() {
        guard
            let grammarsDirectory = Bundle(for: type(of: self)).resourcePath +/ "grammars",
            let sampleFile = Bundle(for: type(of: self)).resourcePath +/ "samples/Sample.swift"
            else { XCTFail(); return }
        let loader = GrammarLoader(searchPaths: grammarsDirectory)
        do {
            guard let grammar = loader.loadGrammar(for: sampleFile.fileURL.uttype.rawValue) else { XCTFail(); return }
            print(grammar)
            print("------------")
            let text = try String(contentsOfFile: sampleFile)
            let matcher = ExampleMatcher(grammar: grammar, options: .verbose)
            matcher.tokenize(CharacterStream(text))
        } catch {
            print(error)
            XCTFail()
        }
    }
    
}