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

///
open class Parser: GrammarEngine {
    
    public func parse(_ tokenStream: TokenStream?, from offset: Int, length: Int? = nil, parentScope: GrammarSyntaxScope? = nil) {
        if let length = length {
            parse(tokenStream, within: NSMakeRange(offset, length), parentScope: parentScope)
        } else {
            parse(tokenStream, within: tokenStream?.range.shiftingLocation(by: offset), parentScope: parentScope)
        }
    }
    
    ///
    /// - parameter tokenStream:
    /// - parameter offset:
    public func parse(_ tokenStream: TokenStream?, within streamRange: NSRange? = nil, parentScope: GrammarSyntaxScope? = nil) {
        guard let tokenStream = tokenStream else { return }
        let characterStream = tokenStream.characterStream
        var streamRange = streamRange ?? tokenStream.range
        while streamRange.location < tokenStream.length {
            var syntaxScope = GrammarSyntaxScope(scopeClass: .parserScope)
            for rule in grammar.parserRules {
                syntaxScope = parse(tokenStream, rule: rule, within: streamRange, parentScope: parentScope)
                if syntaxScope.matches {
                    syntaxScope.rule = rule
                    break
                }
            }
            if syntaxScope.matches && syntaxScope.rule?.has(option: .skip) == false {
                delegate?.grammarEngine?(self,
                                         didGenerate: syntaxScope,
                                         characterStream: characterStream,
                                         tokenStream: tokenStream,
                                         parentScope: parentScope)
            } else {
                let token = tokenStream[streamRange.location]
                delegate?.grammarEngine?(self,
                                         didSkip: token,
                                         characterStream: characterStream,
                                         parentScope: parentScope)
            }
            streamRange.shiftLocation(by: syntaxScope.matches ? syntaxScope.count : 1)
        }
        delegate?.grammarEngine?(self,
                                 didFinishProcessing: characterStream,
                                 tokenStream: tokenStream,
                                 parentScope: parentScope)
    }
    
    ///
    ///
    /// - Parameters:
    ///     - tokenStream:
    ///     - rule:
    ///     - offset:
    ///     - parent:
    /// - Returns:
    public func parse(_ tokenStream: TokenStream, rule: GrammarRule, within streamRange: NSRange, syntaxScope: GrammarSyntaxScope? = nil, parentScope: GrammarSyntaxScope? = nil, metadata: Grammar.Metadata? = nil) -> GrammarSyntaxScope {
        
        let syntaxScope = syntaxScope ?? GrammarSyntaxScope(scopeClass: .parserScope)
        
        syntaxScope.rule = rule
        
        guard rule.isComponent, streamRange.length > 0, streamRange.location < tokenStream.length else { return syntaxScope }
        
        var subtree = GrammarSyntaxScope(scopeClass: .parserScope)
        var matchCount = 0
        var dx = 0
        
        switch rule.componentType {
            
        case .parserRuleReference:
            
            guard let ruleRef = grammar[rule.value] else {
                print(String(format: "No parser rule was defined for id \"%@\"", rule.value))
                return syntaxScope
            }
            
            subtree = parse(tokenStream,
                            rule: ruleRef,
                            within: streamRange,
                            metadata: rule.metadata)
            while rule.inverted != subtree.absoluteMatch {
                if rule.inverted {
                    subtree = GrammarSyntaxScope(scopeClass: .parserScope)
                    let token = tokenStream[streamRange.location + dx]
                    token.metadata = metadata ?? rule.metadata
                    subtree.add(token: token)
                }
                syntaxScope.add(tokens: subtree.tokens)
                matchCount += 1
                dx += subtree.count
                if !rule.quantifier.greedy { break }
                subtree = parse(tokenStream,
                                rule: ruleRef,
                                within: streamRange.shiftingLocation(by: dx),
                                metadata: rule.metadata)
            }
            
            break
            
        case .composite:
            
            if rule.subrules.count > 0 {
                
                for subrule in rule.subrules {
                    subtree = parse(tokenStream,
                                    rule: subrule,
                                    within: streamRange,
                                    metadata: metadata)
                    if rule.inverted != subtree.absoluteMatch { break }
                }
                
                while rule.inverted != subtree.absoluteMatch {
                    if rule.inverted {
                        subtree = GrammarSyntaxScope(scopeClass: .parserScope)
                        let token = tokenStream[streamRange.location + dx]
                        token.metadata = metadata ?? rule.metadata
                        subtree.add(token: token)
                    }
                    syntaxScope.add(tokens: subtree.tokens)
                    matchCount += 1
                    dx += subtree.count
                    if !rule.quantifier.greedy { break }
                    for subrule in rule.subrules {
                        subtree = parse(tokenStream,
                                        rule: subrule,
                                        within: streamRange.shiftingLocation(by: dx),
                                        metadata: metadata)
                        if rule.inverted != subtree.absoluteMatch { break }
                    }
                }
                
            }
            
            break
            
        case .lexerRuleReference, .lexerFragmentReference:
            
            var token = tokenStream[streamRange.location]
            
            var matches = rule.value == token.rule?.id
            while rule.inverted != matches {
                token.metadata = metadata ?? rule.metadata
                syntaxScope.add(token: token)
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
                syntaxScope.add(token: token)
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
                             syntaxScope: syntaxScope,
                             parentScope: parentScope)
            }
            syntaxScope.matches = true
            parentScope?.add(child: syntaxScope)
        }
        
        return syntaxScope
    }
    
}
