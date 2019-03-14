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

/// Grammar engine used to tokenize character streams.
open class Lexer: GrammarEngine {
    
    ///
    ///
    /// - Parameters:
    ///     - characterStream:
    ///     - offset:
    ///     - length:
    public func tokenize(_ characterStream: CharacterStream?, from offset: Int, length: Int? = nil, parentScope: GrammarSyntaxScope? = nil) {
        if let length = length {
            tokenize(characterStream, within: NSMakeRange(offset, length), parentScope: parentScope)
        } else {
            tokenize(characterStream, within: characterStream?.range.shiftingLocation(by: offset), parentScope: parentScope)
        }
    }
    
    ///
    ///
    /// - Parameters:
    ///     - characterStream:
    ///     - streamRange:
    public func tokenize(_ characterStream: CharacterStream?, within streamRange: NSRange? = nil, parentScope: GrammarSyntaxScope? = nil) {
        guard let characterStream = characterStream else { return }
        var streamRange = streamRange ?? characterStream.range
        let tokenStream = TokenStream(characterStream: characterStream)
        while streamRange.location < characterStream.length {
            var scope = GrammarSyntaxScope(scopeClass: .lexerScope)
            for rule in grammar.lexerRules {
                scope = tokenize(characterStream, rule: rule, within: streamRange, parentScope: parentScope)
                if scope.matches || rule == grammar.unmatchedRule {
                    scope.rule = rule
                    break
                }
            }
            if scope.matches && scope.rule?.has(option: .skip) == false {
                let token = scope.generatedToken
                token.rule = scope.rule
                tokenStream.add(token: token)
                if scope.rule == grammar.unmatchedRule {
                    delegate?.grammarEngine?(self,
                                             didSkip: token,
                                             characterStream: characterStream,
                                             parentScope: parentScope)
                } else {
                    delegate?.grammarEngine?(self,
                                             didGenerate: scope,
                                             characterStream: characterStream,
                                             tokenStream: nil,
                                             parentScope: parentScope)
                }
            }
            streamRange.shiftLocation(by: (scope.matches ? scope.length : 1))
        }
        delegate?.grammarEngine?(self,
                                 didFinishProcessing: characterStream,
                                 tokenStream: tokenStream,
                                 parentScope: parentScope)
    }
    
    ///
    /// - parameter characterStream:
    /// - parameter rule:
    /// - parameter offset:
    /// - parameter scope:
    /// - Returns:
    public func tokenize(_ characterStream: CharacterStream, rule: GrammarRule, within streamRange: NSRange, scope: GrammarSyntaxScope? = nil, parentScope: GrammarSyntaxScope? = nil, metadata: Grammar.Metadata? = nil) -> GrammarSyntaxScope {
        
        let scope = scope ?? GrammarSyntaxScope(scopeClass: .lexerScope)
        
        scope.rule = rule
        
        guard rule.isComponent, streamRange.length > 0, streamRange.location < characterStream.length else { return scope }
        let stream = characterStream[streamRange]
        
        var subscope = GrammarSyntaxScope(scopeClass: .lexerScope)
        var matchCount = 0
        var dx = 0
        
        switch rule.componentType {
            
        case .lexerRuleReference, .lexerFragmentReference:
            
            guard let ruleRef = grammar[rule.value]  else {
                print(String(format: "No lexer rule was defined for id \"%@\"", rule.value))
                return scope
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
                    subscope = GrammarSyntaxScope(scopeClass: .lexerScope)
                    subscope.add(token: token)
                }
                scope.add(tokens: subscope.tokens)
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
                        subscope = GrammarSyntaxScope(scopeClass: .lexerScope)
                        subscope.add(token: token)
                    }
                    scope.add(tokens: subscope.tokens)
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
                scope.add(token: token)
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
        
        if (!rule.quantifier.hasRange && matchCount > 0) || rule.quantifier.optional || rule.quantifier.meets(matchCount) {
            if let next = rule.next {
                return tokenize(characterStream,
                                rule: next,
                                within: streamRange.shiftingLocation(by: dx),
                                scope: scope,
                                parentScope: parentScope)
            }
            scope.matches = true
            parentScope?.add(child: scope)
        }
        
        return scope
    }
    
}
