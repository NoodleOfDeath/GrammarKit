//
//  GrammarKit
//
//  Copyright © 2019 NoodleOfDeath. All rights reserved.
//

import XCTest

import SwiftyUTType
import GrammarKit

class Tests: XCTestCase {
    
    func testExample() {
        guard
            let grammarsDirectory = Bundle(for: type(of: self)).resourcePath +/ "grammars",
            let sampleFile = Bundle(for: type(of: self)).resourcePath +/ "samples/Test.swift"
            else { XCTFail(); return }
        let loader = GrammarLoader(searchPaths: grammarsDirectory)
        do {
            guard let grammar = loader.loadGrammar(for: sampleFile.fileURL.uttype.rawValue) else { XCTFail(); return }
            let text = try String(contentsOfFile: sampleFile)
            let engine = ExampleProcessor(grammar: grammar, options: .verbose)
            engine.tokenize(CharacterStream(text))
        } catch {
            print(error)
            XCTFail()
        }
    }
    
}
