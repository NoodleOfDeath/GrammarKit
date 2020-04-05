//
// The MIT License (MIT)
//
// Copyright © 2019 NoodleOfDeath. All rights reserved.
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

/// Grammatical matcher for matching token streams.
open class Parser: GrammaticalMatcher {
    
    /// Parses a token stream.
    ///
    /// - Parameters:
    ///     - tokenStream:
    ///     - offset:
    ///     - length:
    ///     - parentTree:
    public func parse(_ tokenStream: TokenStream?, from offset: Int, length: Int? = nil, parentTree: SyntaxTree? = nil) {
        if let length = length {
            parse(tokenStream, within: NSMakeRange(offset, length), parentTree: parentTree)
        } else {
            parse(tokenStream, within: tokenStream?.range.shiftingLocation(by: offset), parentTree: parentTree)
        }
    }
    
    /// Parses a token stream.
    ///
    /// - Parameters:
    ///     - tokenStream:
    ///     - streamRange:
    ///     - parentTree:
    public func parse(_ tokenStream: TokenStream?, within streamRange: NSRange? = nil, parentTree: SyntaxTree? = nil) {
        guard let tokenStream = tokenStream else { return }
        let characterStream = tokenStream.characterStream
        var streamRange = streamRange ?? tokenStream.range
        while streamRange.location < tokenStream.length {
            var syntaxTree = SyntaxTree(treeClass: .parserTree)
            for rule in grammar.parserRules {
                syntaxTree = parse(tokenStream, rule: rule, within: streamRange, parentTree: parentTree)
                if syntaxTree.matches {
                    syntaxTree.rule = rule
                    break
                }
            }
            if syntaxTree.matches && syntaxTree.rule?.has(option: .skip) == false {
                delegate?.matcher?(self,
                                   didGenerate: syntaxTree,
                                   characterStream: characterStream,
                                   tokenStream: tokenStream,
                                   parentTree: parentTree)
            } else {
                let token = tokenStream[streamRange.location]
                delegate?.matcher?(self,
                                   didSkip: token,
                                   characterStream: characterStream,
                                   parentTree: parentTree)
            }
            streamRange.shiftLocation(by: syntaxTree.matches ? syntaxTree.count : 1)
        }
        delegate?.matcher?(self,
                           didFinishMatching: characterStream,
                           tokenStream: tokenStream,
                           parentTree: parentTree)
    }
    
    ///
    ///
    /// - Parameters:
    ///     - tokenStream:
    ///     - rule:
    ///     - streamRange:
    ///     - syntaxTree:
    ///     - parentTree:
    ///     - metadata:
    /// - Returns:
    public func parse(_ tokenStream: TokenStream, rule: GrammarRule, within streamRange: NSRange, syntaxTree: SyntaxTree? = nil, parentTree: SyntaxTree? = nil, metadata: Metadata? = nil) -> SyntaxTree {
        
        let syntaxTree = syntaxTree ?? SyntaxTree(treeClass: .parserTree)
        
        syntaxTree.rule = rule
        
        guard rule.isComponent, streamRange.length > 0, streamRange.location < tokenStream.length else { return syntaxTree }
        
        var subscope = SyntaxTree(treeClass: .parserTree)
        var matchCount = 0
        var dx = 0
        
        switch rule.componentType {
            
        case .parserRuleReference:
            
            guard let ruleRef = grammar[rule.value] else {
                print(String(format: "No parser rule was defined for id \"%@\"", rule.value))
                return syntaxTree
            }
            
            subscope = parse(tokenStream,
                            rule: ruleRef,
                            within: streamRange,
                            metadata: rule.metadata)
            while rule.inverted != subscope.absoluteMatch {
                if rule.inverted {
                    subscope = SyntaxTree(treeClass: .parserTree)
                    let token = tokenStream[streamRange.location + dx]
                    token.metadata = metadata ?? rule.metadata
                    subscope.add(token: token)
                }
                syntaxTree.add(tokens: subscope.tokens)
                matchCount += 1
                dx += subscope.count
                if !rule.quantifier.greedy { break }
                subscope = parse(tokenStream,
                                 rule: ruleRef,
                                 within: streamRange.shiftingLocation(by: dx),
                                 metadata: rule.metadata)
            }
            
            break
            
        case .composite:
            
            if rule.subrules.count > 0 {
                
                for subrule in rule.subrules {
                    subscope = parse(tokenStream,
                                     rule: subrule,
                                     within: streamRange,
                                     metadata: metadata)
                    if rule.inverted != subscope.absoluteMatch { break }
                }
                
                while rule.inverted != subscope.absoluteMatch {
                    if rule.inverted {
                        subscope = SyntaxTree(treeClass: .parserTree)
                        let token = tokenStream[streamRange.location + dx]
                        token.metadata = metadata ?? rule.metadata
                        subscope.add(token: token)
                    }
                    syntaxTree.add(tokens: subscope.tokens)
                    matchCount += 1
                    dx += subscope.count
                    if !rule.quantifier.greedy { break }
                    for subrule in rule.subrules {
                        subscope = parse(tokenStream,
                                         rule: subrule,
                                         within: streamRange.shiftingLocation(by: dx),
                                         metadata: metadata)
                        if rule.inverted != subscope.absoluteMatch { break }
                    }
                }
                
            }
            
            break
            
        case .lexerRuleReference, .lexerFragmentReference:
            
            var token = tokenStream[streamRange.location]
            
            var matches = rule.value == token.rule?.id
            while rule.inverted != matches {
                token.metadata = metadata ?? rule.metadata
                syntaxTree.add(token: token)
                matchCount += 1
                dx += 1
                if !rule.quantifier.greedy || streamRange.location + dx >= tokenStream.length { break }
                token = tokenStream[streamRange.location + dx]
                matches = rule.value == token.rule?.id
            }
            
            break
            
        default:
            // .literal, .expression
            
            var pattern = rule.value
            if "^\\w+$".doesMatch(rule.value) {
                pattern = String(format: "\\b%@\\b", rule.value)
            }
            
            var token = tokenStream[streamRange.location]
            var matches = pattern.doesMatch(token.value, options: .anchored)
            while rule.inverted != matches {
                token.metadata = metadata ?? rule.metadata
                syntaxTree.add(token: token)
                matchCount += 1
                dx += 1
                if !rule.quantifier.greedy || streamRange.location + dx >= tokenStream.length { break }
                token = tokenStream[streamRange.location + dx]
                matches = pattern.doesMatch(token.value, options: .anchored)
            }
            
            break
            
        }
        
        if (!rule.quantifier.hasRange && matchCount > 0) || rule.quantifier.optional || rule.quantifier.meets(matchCount) {
            if let next = rule.next {
                return parse(tokenStream,
                             rule: next,
                             within: streamRange.shiftingLocation(by: dx),
                             syntaxTree: syntaxTree,
                             parentTree: parentTree)
            }
            syntaxTree.matches = true
            parentTree?.add(child: syntaxTree)
        }
        
        return syntaxTree
    }
    
}
