//
//  GrammarKit
//
//  Copyright © 2019 NoodleOfDeath. All rights reserved.
//

import Foundation

import GrammarKit

///
class ExampleProcessor: CompoundGrammaticalProcessor {
    
    lazy var nestedRanges: [NSRange] = [NSRange]()
    
    ///
    /// - parameter characterStream:
    /// - parameter offset:
    /// - parameter verbose:
    func process(_ characterStream: CharacterStream?, from offset: Int, length: Int? = nil) {
        if let length = length {
            process(characterStream, within: NSMakeRange(offset, length))
        } else {
            process(characterStream, within: characterStream?.range.shiftingLocation(by: offset))
        }
    }
    
    ///
    /// - parameter characterStream:
    /// - parameter offset:
    /// - parameter verbose:
    func process(_ characterStream: CharacterStream?, within streamRange: NSRange? = nil, parentTree: SyntaxTree? = nil) {
        if options.contains(.verbose) {
            print()
            print("----- Tokenizing Character Stream -----")
            print()
        }
        tokenize(characterStream, within: streamRange, parentTree: parentTree)
    }
    
    override func processor(_ processor: GrammaticalProcessor, didGenerate tree: SyntaxTree, characterStream: CharacterStream, tokenStream: TokenStream?, parentTree: SyntaxTree? = nil) {
        super.processor(processor, didGenerate: tree, characterStream: characterStream, tokenStream: tokenStream, parentTree: parentTree)
        if options.contains(.verbose) { print(tree) }
        if tree.rule?.has(option: .nested) == true && tree.maxRange < characterStream.length {
            nestedRanges.append(tree.innerRange)
        }
    }
    
    override func processor(_ processor: GrammaticalProcessor, didFinishProcessing characterStream: CharacterStream, tokenStream: TokenStream?, parentTree: SyntaxTree? = nil) {

        super.processor(processor, didFinishProcessing: characterStream, tokenStream: tokenStream, parentTree: parentTree)
        
        switch processor {
            
        case is Lexer:
            guard let tokenStream = tokenStream else { return }
            if options.contains(.verbose) {
                print()
                print("Lexer did finish tokenizing character stream")
                print(String(format: "%ld tokens were found", tokenStream.length))
                print()
                print("----- Parsing Token Stream -----")
                print()
            }
            parser?.parse(tokenStream)
            break
            
        case is Parser:
            if options.contains(.verbose) {
                print()
                print("Parser did finish parsing token stream")
                print()
            }
            if nestedRanges.count > 0 {
                let range = nestedRanges.removeFirst()
                if range.max < characterStream.length {
                    process(characterStream, from: range.max)
                }
            }
            break
            
        default:
            break
            
        }
        
    }
    
}
