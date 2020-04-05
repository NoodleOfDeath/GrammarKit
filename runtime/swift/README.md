# GrammarKit

[![CI Status](https://img.shields.io/travis/NoodleOfDeath/GrammarKit.svg?style=flat)](https://travis-ci.org/NoodleOfDeath/GrammarKit)
[![Version](https://img.shields.io/cocoapods/v/GrammarKit.svg?style=flat)](https://cocoapods.org/pods/GrammarKit)
[![License](https://img.shields.io/cocoapods/l/GrammarKit.svg?style=flat)](https://cocoapods.org/pods/GrammarKit)
[![Platform](https://img.shields.io/cocoapods/p/GrammarKit.svg?style=flat)](https://cocoapods.org/pods/GrammarKit)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

```ruby
pod 'GrammarKit'
```

## Author

NoodleOfDeath, git@noodleofdeath.com

## License

GrammarKit is available under the MIT license. See the LICENSE file for more info.

## Usage

```swift
import XCTest
import GrammarKit

class Tests: XCTestCase {

    func testExample() {
        guard
            let grammarsDirectory = Bundle(for: type(of: self)).resourcePath?.ns.appendingPathComponent("grammars"),
            let sampleFile = Bundle(for: type(of: self)).path(forResource: "samples/Test", ofType: "swift")
            else { XCTFail(); return }
        let loader = GrammarLoader(searchPaths: grammarsDirectory)
        do {
            guard let grammar = loader.load(with: "public.swift-source") else { XCTFail(); return }
            let text = try String(contentsOfFile: sampleFile)
            let engine = CompoundGPEngine(grammar: grammar)
            engine.match(text, options: .verbose)
        } catch {
            print(error)
            XCTFail()
        }
    }

}
```

