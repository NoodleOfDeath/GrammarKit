//
// The MIT License (MIT)
//
// Copyright © 2020 NoodleOfDeath. All rights reserved.
// NoodleOfDeath
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation

import GrammarKit

/// Custom example scanner that recusively tokenizes and parses character
/// streams.
class ExampleScanner: CompoundGrammaticalScanner {

    /// Nested ranges that will be recursively scanned byt the scanner.
    lazy var nestedRanges = [NSRange]()

    // MARK: - GrammaticalScannerDelegate Methods
    
    override func scanner(_ scanner: GrammaticalScanner, didGenerate matchChain: MatchChain, characterStream: CharacterStream, tokenStream: TokenStream<Token>?) {
        super.scanner(scanner, didGenerate: matchChain, characterStream: characterStream, tokenStream: tokenStream)
        print(">>> Match: \(matchChain)")
        if let rule = matchChain.rule, rule.isRule == true, let subchain = matchChain.subchains.first {
            subchain.subchains.enumerated().forEach({
                guard
                    let groupName = $0.1.rule?.groupName,
                    let metadata = rule.groups[groupName],
                    metadata.options.contains(.nested) else { return }
                nestedRanges.append($0.1.range)
            })
        }
    }
    
    override func scanner(_ scanner: GrammaticalScanner, didFinishScanning characterStream: CharacterStream, tokenStream: TokenStream<Token>?) {

        super.scanner(scanner, didFinishScanning: characterStream, tokenStream: tokenStream)
        
        switch scanner {
            
        case is Lexer:
            guard let tokenStream = tokenStream else { return }
            print()
            print("Lexer did finish tokenizing character stream")
            print(String(format: "%ld tokens were found", tokenStream.length))
            print()
            print("----- Parsing Token Stream (\(tokenStream.tokenCount) tokens) \(tokenStream.range) -----")
            print()
            parser?.parse(tokenStream)

        case is Parser:
            print()
            print("Parser did finish parsing token stream")
            print()
            if nestedRanges.count > 0 {
                let range = nestedRanges.removeFirst()
                if range.max < characterStream.length {
                    scan(characterStream, within: range)
                }
            }

        default:
            break

        }
        
    }

    // MARK: - Instance Methods

    ///
    /// - parameter characterStream:
    /// - parameter offset:
    /// - parameter verbose:
    func scan(_ characterStream: CharacterStream?, from offset: Int = 0, length: Int? = nil, rules: [GrammarRule]? = nil) {
        if let length = length {
            scan(characterStream, within: NSMakeRange(offset, length), rules: rules)
        } else {
            scan(characterStream, within: characterStream?.range.shiftingLocation(by: offset), rules: rules)
        }
    }

    func scan(_ characterStream: String?, from offset: Int = 0, length: Int? = nil, rules: [GrammarRule]? = nil) {
        scan(IO.CharacterStream(characterStream), from: offset, length: length, rules: rules)
    }

    ///
    /// - parameter characterStream:
    /// - parameter offset:
    /// - parameter verbose:
    fileprivate func scan(_ characterStream: CharacterStream?, within streamRange: NSRange? = nil, rules: [GrammarRule]? = nil) {
        print()
        print("----- Tokenizing Character Stream (\(streamRange ?? .zero) -----")
        print()
        tokenize(characterStream, within: streamRange, rules: rules)
    }
    
}
