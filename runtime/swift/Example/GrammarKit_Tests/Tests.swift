//
//  GrammarKit
//
//  Copyright © 2020 NoodleOfDeath. All rights reserved.
//

import XCTest

import SwiftyUTType
import GrammarKit

class Tests: XCTestCase {

    func testTokenizing() {
        guard
            let grammarsDirectory = Bundle(for: type(of: self)).resourcePath +/ "grammars",
            let sampleDirectory = Bundle(for: type(of: self)).resourcePath +/ "samples"
            else { XCTFail(); return }
        let loader = GrammarLoader(searchPaths: grammarsDirectory)
        guard let sampleFiles = try? FileManager.default.contentsOfDirectory(atPath: sampleDirectory) else { XCTFail(); return }
        sampleFiles.forEach({
            let sampleFile = sampleDirectory +/ $0
            do {
                print("----- Testing \(sampleFile.fileURL.uttype.rawValue) -----")
                guard let grammar = loader.loadGrammar(for: sampleFile.fileURL.uttype.rawValue) else { XCTFail(); return }
                print(grammar)
                print("------------")
                let text = try String(contentsOfFile: sampleFile)
                let matcher = ExampleMatcher(grammar: grammar)
                matcher.tokenize(IO.CharacterStream(text))
            } catch {
                print(error)
                XCTFail()
            }
        })
    }
    
}
