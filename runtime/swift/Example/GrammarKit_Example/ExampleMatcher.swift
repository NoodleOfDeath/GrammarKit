//
//  GrammarKit
//
//  Copyright © 2020 NoodleOfDeath. All rights reserved.
//

import Foundation

import GrammarKit

///
class ExampleMatcher: CompoundGrammaticalMatcher {
    
    lazy var nestedRanges = [NSRange]()
    
    ///
    /// - parameter characterStream:
    /// - parameter offset:
    /// - parameter verbose:
    func match(_ characterStream: CharacterStream?, from offset: Int, length: Int? = nil, rules: [GrammarRule]? = nil) {
        if let length = length {
            match(characterStream, within: NSMakeRange(offset, length), rules: rules)
        } else {
            match(characterStream, within: characterStream?.range.shiftingLocation(by: offset), rules: rules)
        }
    }
    
    ///
    /// - parameter characterStream:
    /// - parameter offset:
    /// - parameter verbose:
    func match(_ characterStream: CharacterStream?, within streamRange: NSRange? = nil, rules: [GrammarRule]? = nil) {
        print()
        print("----- Tokenizing Character Stream (\(streamRange ?? .zero) -----")
        print()
        tokenize(characterStream, within: streamRange, rules: rules)
    }
    
    override func matcher(_ matcher: GrammaticalMatcher, didGenerate matchChain: MatchChain, characterStream: CharacterStream, tokenStream: TokenStream<Token>?) {
        super.matcher(matcher, didGenerate: matchChain, characterStream: characterStream, tokenStream: tokenStream)
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
    
    override func matcher(_ matcher: GrammaticalMatcher, didFinishMatching characterStream: CharacterStream, tokenStream: TokenStream<Token>?) {

        super.matcher(matcher, didFinishMatching: characterStream, tokenStream: tokenStream)
        
        switch matcher {
            
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
                    match(characterStream, within: range)
                }
            }

        default:
            break

        }
        
    }
    
}
