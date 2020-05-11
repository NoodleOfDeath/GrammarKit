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
    public func tokenize(_ characterStream: CharacterStream?, from offset: Int, length: Int? = nil, rules: [GrammarRule]? = nil) {
        if let length = length {
            tokenize(characterStream, within: NSMakeRange(offset, length), rules: rules)
        } else {
            tokenize(characterStream, within: characterStream?.range.shiftingLocation(by: offset), rules: rules)
        }
    }
    
    ///
    ///
    /// - Parameters:
    ///     - characterStream:
    ///     - streamRange:
    ///     - parentChain:
    ///     - rules:
    public func tokenize(_ characterStream: CharacterStream?, within streamRange: NSRange? = nil, rules: [GrammarRule]? = nil) {
        guard let characterStream = characterStream else { return }
        var streamRange = streamRange ?? characterStream.range
        let tokenStream = TokenStream<Token>(characterStream: characterStream)
        while streamRange.location < characterStream.length {
            var matchChain = MatchChain()
            for rule in (rules ?? grammar.lexerRules) {
                matchChain = tokenize(characterStream, rule: rule, within: streamRange)
                if matchChain.matches || rule == grammar.unmatchedRule {
                    matchChain.rule = rule
                    break
                }
            }
            if (matchChain.matches && matchChain.has(option: .skip) == false) {
                let token = matchChain.asToken
                if let rule = matchChain.rule {
                    token.add(rule: rule)
                }
                tokenStream.add(token: token)
                if matchChain.rule == grammar.unmatchedRule {
                    delegate?.matcher(self, didSkip: token,
                                      characterStream: characterStream)
                } else {
                    delegate?.matcher(self, didGenerate: matchChain,
                                      characterStream: characterStream,
                                      tokenStream: nil)
                }
            }
            streamRange.shiftLocation(by: (matchChain.matches ? matchChain.length : 1))
        }
        delegate?.matcher(self, didFinishMatching: characterStream, tokenStream: tokenStream)
    }
    
    ///
    ///
    /// - Parameters:
    ///     - characterStream:
    ///     - rule:
    ///     - offset:
    ///     - matchChain:
    ///     - metadata:
    /// - Returns:
    public func tokenize(_ characterStream: CharacterStream, rule: GrammarRule, within streamRange: NSRange, matchChain: MatchChain? = nil, captureGroups: [String: MatchChain]? = nil, depth: Int = 0) -> MatchChain {
        
        let matchChain = matchChain ?? MatchChain(rule: rule)
        var captureGroups = captureGroups ?? [:]

        guard rule.isValid, streamRange.length > 0, streamRange.location < characterStream.length else { return matchChain }
        let stream = characterStream[streamRange]

        var subchain = MatchChain(rule: rule)
        var tmpChain = MatchChain(rule: rule)
        var matchCount = 0
        var dx = 0
        
        switch rule.type {
            
        case .lexerRuleReference:
            
            guard let ruleRef = grammar[rule.value]  else {
                print(String(format: "WARNING: No lexer rule was defined for id \"%@\"", rule.value))
                return matchChain
            }

            tmpChain = tokenize(characterStream, rule: ruleRef, within: streamRange, captureGroups: captureGroups, depth: depth + (rule.rootAncestor?.id == ruleRef.id ? 1 : 0))
            while rule.inverted != tmpChain.absoluteMatch {
                if rule.inverted {
                    let token = Token(value: stream.firstCharacter,
                                      start: streamRange.location + dx,
                                      length: 1, rules: [rule])
                    tmpChain = MatchChain(rule: rule)
                    tmpChain.rule = rule
                    tmpChain.add(token: token)
                }
                subchain.add(subchain: tmpChain)
                subchain.add(tokens: tmpChain.tokens)
                matchCount += 1
                dx += tmpChain.length
                if !rule.quantifier.greedy { break }
                tmpChain = tokenize(characterStream, rule: ruleRef,
                                    within: streamRange.shiftingLocation(by: dx),
                                    captureGroups: captureGroups, depth: depth)
            }

        case .lexerRule, .composite:
            
            if rule.subrules.count > 0 {
                
                for subrule in rule.subrules {
                    tmpChain = tokenize(characterStream, rule: subrule, within: streamRange, captureGroups: captureGroups, depth: depth)
                    if rule.inverted != tmpChain.absoluteMatch { break }
                }

                while rule.inverted != tmpChain.absoluteMatch {
                    if rule.inverted {
                        let token = Token(value: stream.firstCharacter,
                                          start: streamRange.location + dx,
                                          length: 1, rules: [rule])
                        tmpChain = MatchChain(rule: rule)
                        tmpChain.rule = rule
                        tmpChain.add(token: token)
                    }
                    if rule.isRule {
                        subchain.add(subchain: tmpChain)
                        subchain.add(tokens: tmpChain.tokens)
                    }
                    matchCount += 1
                    dx += tmpChain.length
                    if !rule.quantifier.greedy { break }
                    for subrule in rule.subrules {
                        tmpChain = tokenize(characterStream, rule: subrule,
                                            within: streamRange.shiftingLocation(by: dx),
                                            captureGroups: captureGroups, depth: depth)
                        if rule.inverted != tmpChain.absoluteMatch { break }
                    }
                }
                if rule.type == .composite {
                    let token = Token(value: stream.substring(with: NSMakeRange(stream.range.location, dx)),
                                      start: streamRange.location, length: dx, rules: [rule])
                    tmpChain = MatchChain(rule: rule, tokens: [token])
                    subchain.add(subchain: tmpChain)
                    subchain.add(tokens: tmpChain.tokens)
                }

            }

        case .captureGroupReference:
            let key = "\(depth).\(rule.value)"
            if let captureGroup = captureGroups[key] {
                var range = stream.range
                var match = captureGroup.string.firstMatch(in: stream, options: .anchored, range: range)
                while rule.inverted != (match != nil) {
                    if !rule.inverted, let match = match {
                        dx += match.range.length
                    } else {
                        dx += 1
                    }
                    matchCount += 1
                    if !rule.quantifier.greedy { break }
                    range = NSMakeRange(dx, stream.length - dx)
                    match = captureGroup.string.firstMatch(in: stream, options: .anchored, range: range)
                }
                let token = Token(value: stream.substring(with: NSMakeRange(stream.range.location, dx)),
                                  start: streamRange.location, length: dx, rules: [rule])
                tmpChain.add(token: token)
                tmpChain.rule = rule
                subchain.add(subchain: tmpChain)
                subchain.add(tokens: tmpChain.tokens)
            }

        default:
            // .literal, .expression
            
            var pattern = rule.value
            if rule != grammar.unmatchedRule && "^\\w+$".doesMatch(rule.value) {
                pattern = String(format: "\\b%@\\b", rule.value)
            }
            
            var range = stream.range
            var match = pattern.firstMatch(in: stream, options: .anchored, range: range)
            while rule.inverted != (match != nil) {
                if !rule.inverted, let match = match {
                    dx += match.range.length
                } else {
                    dx += 1
                }
                matchCount += 1
                if !rule.quantifier.greedy { break }
                range = NSMakeRange(dx, stream.length - dx)
                match = pattern.firstMatch(in: stream, options: .anchored, range: range)
            }
            let token = Token(value: stream.substring(with: NSMakeRange(stream.range.location, dx)),
                              start: streamRange.location, length: dx, rules: [rule])
            tmpChain.add(token: token)
            tmpChain.rule = rule
            subchain.add(subchain: tmpChain)
            subchain.add(tokens: tmpChain.tokens)

        }

        if let s = matchChain.add(subchains: subchain.subchains) {
            subchain = s
        }
        matchChain.add(tokens: subchain.tokens)

        if let groupName = rule.groupName, subchain.length > 0 {
            let key = "\(depth).\(groupName)"
            captureGroups[key] = subchain
        }

        if (!rule.quantifier.hasRange && matchCount > 0) || rule.quantifier.optional || rule.quantifier.matches(matchCount) {
            if let next = rule.next {
                let remainingRange = streamRange.shiftingLocation(by: dx)
                if remainingRange.length > 0 {
                    return tokenize(characterStream, rule: next,
                                    within: remainingRange, matchChain: matchChain,
                                    captureGroups: captureGroups, depth: depth)
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
