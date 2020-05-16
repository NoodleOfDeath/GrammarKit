//
//  GrammarKit
//
//  Copyright © 2020 NoodleOfDeath. All rights reserved.
//

import XCTest

import SwiftyUTType
import GrammarKit

class Tests: XCTestCase {

    var resourcePath: String = ""
    var grammarsDirectory: String { return resourcePath +/ "grammars" }
    var samplesDirectory: String { return resourcePath +/ "samples" }

    lazy var grammarLoader: GrammarLoader = GrammarLoader(searchPaths: grammarsDirectory)

    override func setUp() {
        super.setUp()
        guard let resourcePath = Bundle(for: type(of: self)).resourcePath else { XCTFail(); return }
        self.resourcePath = resourcePath
    }

    func testXML() {
        test(sample: "Sample.xml")
    }

    func testHTML() {
        test(sample: "Sample.html")
    }

    func testSwift() {
        test(sample: "Sample.swift")
    }

    func testJava() {
        test(sample: "Sample.java")
    }

    fileprivate func test(sample: String) {
        let sampleFile = samplesDirectory +/ sample
        do {
            print("----- Testing \(sampleFile.fileURL.uttype.rawValue) -----")
            guard let grammar = grammarLoader.loadGrammar(for: sampleFile.fileURL.uttype.rawValue) else { XCTFail(); return }
            print(grammar)
            print("------------")
            let text = try String(contentsOfFile: sampleFile)
            let matcher = ExampleMatcher(grammar: grammar)
            matcher.match(IO.CharacterStream(text))
        } catch {
            print(error)
            XCTFail()
        }
    }
    
}
