//
//  GrammarKit
//
//  Copyright © 2020 NoodleOfDeath. All rights reserved.
//

import XCTest

import SwiftyUTType
import GrammarKit

/// Runs GrammarLooder and GrammaticalScanner tests.
class SampleTests: XCTestCase {

    var resourcePath: String = ""
    var grammarsDirectory: String { return resourcePath +/ "grammars" }
    var samplesDirectory: String { return resourcePath +/ "samples" }

    lazy var grammarLoader: GrammarLoader = GrammarLoader(searchPaths: grammarsDirectory)

    enum Expectation: String {
        case lexerRuleCount
    }

    override func setUp() {
        super.setUp()
        guard let resourcePath = Bundle(for: type(of: self)).resourcePath else { XCTFail(); return }
        self.resourcePath = resourcePath
    }

    func testXML() {
        test(sample: "Sample.xml", expectations: [
            .lexerRuleCount: 18,
        ])
    }

    func testHTML() {
        test(sample: "Sample.html", expectations: [
            .lexerRuleCount: 18,
        ])
    }

    func testSwift() {
        test(sample: "Sample.swift", expectations: [
            .lexerRuleCount: 48,
        ])
    }

    func testJava() {
        test(sample: "Sample.java", expectations: [
            .lexerRuleCount: 44,
        ])
    }

    fileprivate func test(sample: String, expectations: [Expectation: Any] = [:]) {
        let sampleFile = samplesDirectory +/ sample
        do {

            print("----- Testing \(sampleFile.fileURL.uttype.rawValue) -----")
            guard let grammar = grammarLoader.loadGrammar(for: sampleFile.fileURL.uttype.rawValue) else { XCTFail(); return }
            //print(grammar)
            print("------------")
            let text = try String(contentsOfFile: sampleFile)

            // Run GrammarLoader tests.
            XCTAssertEqual(expectations[.lexerRuleCount] as? Int, grammar.lexerRules.count)

            // Run ExampleScanner tests.
            let scanner = ExampleScanner(grammar: grammar)
            scanner.scan(text)

        } catch {
            print(error)
            XCTFail()
        }
    }
    
}
