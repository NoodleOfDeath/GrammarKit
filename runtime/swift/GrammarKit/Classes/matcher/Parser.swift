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

/// Grammatical matcher for matching token streams.
open class Parser: BaseGrammaticalMatcher {
    
    /// Parses a token stream.
    ///
    /// - Parameters:
    ///     - tokenStream:
    ///     - offset:
    ///     - length:
    ///     - parentChain:
    public func parse(_ tokenStream: TokenStream<Token>?, from offset: Int, length: Int? = nil, rules: [GrammarRule]? = nil) {
        if let length = length {
            parse(tokenStream, within: NSMakeRange(offset, length), rules: rules)
        } else {
            parse(tokenStream, within: tokenStream?.range.shiftingLocation(by: offset), rules: rules)
        }
    }
    
    /// Parses a token stream.
    ///
    /// - Parameters:
    ///     - tokenStream:
    ///     - streamRange:
    ///     - parentChain:
    public func parse(_ tokenStream: TokenStream<Token>?, within streamRange: NSRange? = nil, rules: [GrammarRule]? = nil) {
        guard let tokenStream = tokenStream else { return }
        let characterStream = tokenStream.characterStream
        var streamRange = streamRange ?? NSMakeRange(0, tokenStream.tokenCount)
        while streamRange.location < tokenStream.tokenCount {
            var matchChain = MatchChain()
            for rule in (rules ?? grammar.parserRules) {
                matchChain = parse(tokenStream, rule: rule, within: streamRange)
                if matchChain.matches {
                    matchChain.rule = rule
                    break
                }
            }
            if matchChain.matches && matchChain.has(option: .skip) == false {
                delegate?.matcher(self, didGenerate: matchChain,
                                  characterStream: characterStream,
                                  tokenStream: tokenStream)
            } else {
                let token = tokenStream[streamRange.location]
                delegate?.matcher(self, didSkip: token, characterStream: characterStream)
            }
            streamRange.shiftLocation(by: matchChain.matches ? matchChain.tokenCount : 1)
        }
        delegate?.matcher(self, didFinishMatching: characterStream, tokenStream: tokenStream)
    }
    
    ///
    ///
    /// - Parameters:
    ///     - tokenStream:
    ///     - rule:
    ///     - streamRange:
    ///     - matchChain:
    ///     - parentChain:
    ///     - metadata:
    /// - Returns:
    public func parse(_ tokenStream: TokenStream<Token>, rule: GrammarRule, within streamRange: NSRange, matchChain: MatchChain? = nil) -> MatchChain {
        
        let matchChain = matchChain ?? MatchChain(rule: rule)

        guard rule.isValid, streamRange.length > 0, streamRange.location <= tokenStream.tokenCount else {
            return matchChain
        }
        
        let subchain = MatchChain(rule: rule)
        var tmpChain = MatchChain(rule: rule)
        var matchCount = 0
        var dx = 0
        
        switch rule.type {
            
        case .parserRuleReference:
            
            guard let ruleRef = grammar[rule.value] else {
                print(String(format: "No parser rule was defined for id \"%@\"", rule.value))
                return matchChain
            }
            tmpChain = parse(tokenStream, rule: ruleRef, within: streamRange)
            while rule.inverted != tmpChain.absoluteMatch {
                if rule.inverted {
                    let token = tokenStream[streamRange.location + dx]
                    tmpChain = MatchChain(rule: rule)
                    tmpChain.rule = rule
                    tmpChain.add(token: token)
                }
                subchain.add(subchain: tmpChain)
                subchain.add(tokens: tmpChain.tokens)
                matchCount += 1
                dx += tmpChain.tokenCount
                if !rule.quantifier.greedy { break }
                tmpChain = parse(tokenStream, rule: ruleRef,
                                 within: streamRange.shiftingLocation(by: dx))
            }

        case .lexerRuleReference:

            var isRef = false
            if let ruleRef = grammar.rules[rule.value], ruleRef.isFragment {
                isRef = true
                tmpChain = parse(tokenStream, rule: ruleRef, within: streamRange)
            }

            var token = tokenStream[streamRange.location]
            var matches = token.matches(rule.value) || tmpChain.matches

            while rule.inverted != matches {
                if !isRef { tmpChain.add(token: token) }
                matchCount += 1
                dx += tmpChain.tokenCount
                if !rule.quantifier.greedy || streamRange.location + dx >= tokenStream.tokenCount { break }
                isRef = false
                if let ruleRef = grammar.rules[rule.value], ruleRef.isFragment {
                    isRef = true
                    tmpChain = parse(tokenStream, rule: ruleRef, within: streamRange)
                }
                token = tokenStream[streamRange.location + dx]
                matches = token.matches(rule.value) || tmpChain.matches
            }
            subchain.add(subchain: tmpChain)
            subchain.add(tokens: tmpChain.tokens)

        case .parserRule, .lexerRule, .composite:
            
            if rule.subrules.count > 0 {

                for subrule in rule.subrules {
                    tmpChain = parse(tokenStream, rule: subrule, within: streamRange)
                    if rule.inverted != tmpChain.absoluteMatch { break }
                }

                var subtokens = [Token]()
                while rule.inverted != tmpChain.absoluteMatch {
                    if rule.inverted {
                        let token = tokenStream[streamRange.location + dx]
                        tmpChain = MatchChain(rule: rule)
                        tmpChain.rule = rule
                        tmpChain.add(token: token)
                    }
                    if rule.isRule {
                        subchain.add(subchain: tmpChain)
                        subchain.add(tokens: tmpChain.tokens)
                    } else {
                        subtokens.append(contentsOf: tmpChain.tokens)
                    }
                    matchCount += 1
                    dx += tmpChain.tokenCount
                    if !rule.quantifier.greedy { break }
                    for subrule in rule.subrules {
                        tmpChain = parse(tokenStream, rule: subrule,
                                         within: streamRange.shiftingLocation(by: dx))
                        if rule.inverted != tmpChain.absoluteMatch { break }
                    }
                }
                if rule.type == .composite {
                    tmpChain = MatchChain(rule: rule, tokens: subtokens)
                    subchain.add(subchain: tmpChain)
                    subchain.add(tokens: tmpChain.tokens)
                }

            }

        case .captureGroupReference:
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
                tmpChain.add(token: token)
                matchCount += 1
                dx += 1
                if !rule.quantifier.greedy || streamRange.location + dx >= tokenStream.tokenCount { break }
                token = tokenStream[streamRange.location + dx]
                matches = pattern.doesMatch(token.value, options: .anchored)
            }
            subchain.add(subchain: tmpChain)
            subchain.add(tokens: tmpChain.tokens)
            
        }

        matchChain.add(subchains: subchain.subchains)
        matchChain.add(tokens: subchain.tokens)
        
        if (!rule.quantifier.hasRange && matchCount > 0) || rule.quantifier.optional || rule.quantifier.matches(matchCount) {
            if let next = rule.next {
                let remainingRange = streamRange.shiftingLocation(by: dx)
                if remainingRange.length > 0 {
                    return parse(tokenStream, rule: next, within: remainingRange, matchChain: matchChain)
                }
                if !next.quantifier.optional {
                    return matchChain
                }
            }
            matchChain.matches = true
        }

        return matchChain

    }
    
}
