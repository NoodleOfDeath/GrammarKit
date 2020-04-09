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

/// Grammar matcher used to tokenize character streams.
open class Lexer: BaseGrammaticalMatcher {
    
    ///
    ///
    /// - Parameters:
    ///     - characterStream:
    ///     - offset:
    ///     - length:
    public func tokenize(_ characterStream: CharacterStream?, from offset: Int, length: Int? = nil, parentTree: SyntaxTree? = nil) {
        if let length = length {
            tokenize(characterStream, within: NSMakeRange(offset, length), parentTree: parentTree)
        } else {
            tokenize(characterStream, within: characterStream?.range.shiftingLocation(by: offset), parentTree: parentTree)
        }
    }
    
    ///
    ///
    /// - Parameters:
    ///     - characterStream:
    ///     - streamRange:
    public func tokenize(_ characterStream: CharacterStream?, within streamRange: NSRange? = nil, parentTree: SyntaxTree? = nil) {
        guard let characterStream = characterStream else { return }
        var streamRange = streamRange ?? characterStream.range
        let tokenStream = TokenStream(characterStream: characterStream)
        while streamRange.location < characterStream.length {
            var syntaxTree = SyntaxTree(treeClass: .lexerTree)
            for rule in grammar.lexerRules {
                syntaxTree = tokenize(characterStream, rule: rule, within: streamRange, parentTree: parentTree)
                if syntaxTree.matches || rule == grammar.unmatchedRule {
                    syntaxTree.rule = rule
                    break
                }
            }
            if syntaxTree.matches && syntaxTree.rule?.has(option: .skip) == false {
                let token = syntaxTree.generatedToken
                token.rule = syntaxTree.rule
                tokenStream.add(token: token)
                if syntaxTree.rule == grammar.unmatchedRule {
                    delegate?.matcher(self,
                                      didSkip: token,
                                      characterStream: characterStream,
                                      parentTree: parentTree)
                } else {
                    delegate?.matcher(self,
                                      didGenerate: syntaxTree,
                                      characterStream: characterStream,
                                      tokenStream: nil,
                                      parentTree: parentTree)
                }
            }
            streamRange.shiftLocation(by: (syntaxTree.matches ? syntaxTree.length : 1))
        }
        delegate?.matcher(self,
                          didFinishMatching: characterStream,
                          tokenStream: tokenStream,
                          parentTree: parentTree)
    }
    
    ///
    /// - parameter characterStream:
    /// - parameter rule:
    /// - parameter offset:
    /// - parameter syntaxTree:
    /// - Returns:
    public func tokenize(_ characterStream: CharacterStream, rule: GrammarRule, within streamRange: NSRange, syntaxTree: SyntaxTree? = nil, parentTree: SyntaxTree? = nil, metadata: Metadata? = nil) -> SyntaxTree {
        
        let syntaxTree = syntaxTree ?? SyntaxTree(treeClass: .lexerTree)
        
        syntaxTree.rule = rule
        
        guard rule.isComponent, streamRange.length > 0, streamRange.location < characterStream.length else { return syntaxTree }
        let stream = characterStream[streamRange]
        
        var subscope = SyntaxTree(treeClass: .lexerTree)
        var matchCount = 0
        var dx = 0
        
        switch rule.componentType {
            
        case .lexerRuleReference, .lexerFragmentReference:
            
            guard let ruleRef = grammar[rule.value]  else {
                print(String(format: "No lexer rule was defined for id \"%@\"", rule.value))
                return syntaxTree
            }

            subscope = tokenize(characterStream,
                                rule: ruleRef,
                                within: streamRange,
                                metadata: rule.metadata)
            while rule.inverted != subscope.absoluteMatch {
                if rule.inverted {
                    let token = Token(rule: rule,
                                      value: stream.firstCharacter,
                                      start: streamRange.location + dx,
                                      length: 1)
                    token.metadata = metadata ?? rule.metadata
                    subscope = SyntaxTree(treeClass: .lexerTree)
                    subscope.add(token: token)
                }
                syntaxTree.add(tokens: subscope.tokens)
                matchCount += 1
                dx += subscope.length
                if !rule.quantifier.greedy { break }
                subscope = tokenize(characterStream,
                                    rule: ruleRef,
                                    within: streamRange.shiftingLocation(by: dx),
                                    metadata: rule.metadata)
            }
            
            break
            
        case .composite:
            
            if rule.subrules.count > 0 {
                
                for subrule in rule.subrules {
                    subscope = tokenize(characterStream,
                                        rule: subrule,
                                        within: streamRange,
                                        metadata: metadata)
                    if rule.inverted != subscope.absoluteMatch { break }
                }
                
                while rule.inverted != subscope.absoluteMatch {
                    if rule.inverted {
                        let token = Token(rule: rule,
                                          value: stream.firstCharacter,
                                          start: streamRange.location + dx,
                                          length: 1)
                        token.metadata = metadata ?? rule.metadata
                        subscope = SyntaxTree(treeClass: .lexerTree)
                        subscope.add(token: token)
                    }
                    syntaxTree.add(tokens: subscope.tokens)
                    matchCount += 1
                    dx += subscope.length
                    if !rule.quantifier.greedy { break }
                    for subrule in rule.subrules {
                        subscope = tokenize(characterStream,
                                            rule: subrule,
                                            within: streamRange.shiftingLocation(by: dx),
                                            metadata: metadata)
                        if rule.inverted != subscope.absoluteMatch { break }
                    }
                }
                
            }
                
            break
            
        default:
            // .literal, .expression
            
            var pattern = rule.value
            if rule != grammar.unmatchedRule && "^\\w+$".doesMatch(rule.value) {
                pattern = String(format: "\\b%@\\b", rule.value)
            }
            
            var range = stream.range
            var match = pattern.firstMatch(in: stream,
                                           options: .anchored,
                                           range: range)
            while rule.inverted != (match != nil) {
                var token: Token
                if !rule.inverted, let match = match {
                    token = Token(rule: rule,
                                  value: stream.substring(with: match.range),
                                  start: streamRange.location + dx,
                                  length: match.range.length)
                } else {
                    token = Token(rule: rule,
                                  value: stream.firstCharacter,
                                  start: streamRange.location + dx,
                                  length: 1)
                }
                token.metadata = metadata ?? rule.metadata
                syntaxTree.add(token: token)
                matchCount += 1
                dx += token.value.length
                if !rule.quantifier.greedy { break }
                range = NSMakeRange(dx, stream.length - dx)
                match = pattern.firstMatch(in: stream,
                                           options: .anchored,
                                           range: range)
            }
                
            break
            
        }
        
        if (!rule.quantifier.hasRange && matchCount > 0) || rule.quantifier.optional || rule.quantifier.matches(matchCount) {
            if let next = rule.next {
                return tokenize(characterStream,
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
