//
//  GrammarKit
//
//  Copyright © 2019 NoodleOfDeath. All rights reserved.
//

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
            var syntaxScope = GrammarSyntaxScope(scopeClass: .lexerScope)
            for rule in grammar.lexerRules {
                syntaxScope = tokenize(characterStream, rule: rule, within: streamRange, parentScope: parentScope)
                if syntaxScope.matches || rule == grammar.unmatchedRule {
                    syntaxScope.rule = rule
                    break
                }
            }
            if syntaxScope.matches && syntaxScope.rule?.has(option: .skip) == false {
                let token = syntaxScope.generatedToken
                token.rule = syntaxScope.rule
                tokenStream.add(token: token)
                if syntaxScope.rule == grammar.unmatchedRule {
                    delegate?.grammarEngine?(self,
                                             didSkip: token,
                                             characterStream: characterStream,
                                             parentScope: parentScope)
                } else {
                    delegate?.grammarEngine?(self,
                                             didGenerate: syntaxScope,
                                             characterStream: characterStream,
                                             tokenStream: nil,
                                             parentScope: parentScope)
                }
            }
            streamRange.shiftLocation(by: (syntaxScope.matches ? syntaxScope.length : 1))
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
    /// - parameter syntaxScope:
    /// - Returns:
    public func tokenize(_ characterStream: CharacterStream, rule: GrammarRule, within streamRange: NSRange, syntaxScope: GrammarSyntaxScope? = nil, parentScope: GrammarSyntaxScope? = nil, metadata: Grammar.Metadata? = nil) -> GrammarSyntaxScope {
        
        let syntaxScope = syntaxScope ?? GrammarSyntaxScope(scopeClass: .lexerScope)
        
        syntaxScope.rule = rule
        
        guard rule.isComponent, streamRange.length > 0, streamRange.location < characterStream.length else { return syntaxScope }
        let stream = characterStream[streamRange]
        
        var subtree = GrammarSyntaxScope(scopeClass: .lexerScope)
        var matchCount = 0
        var dx = 0
        
        switch rule.componentType {
            
        case .lexerRuleReference, .lexerFragmentReference:
            
            guard let ruleRef = grammar[rule.value]  else {
                print(String(format: "No lexer rule was defined for id \"%@\"", rule.value))
                return syntaxScope
            }

            subtree = tokenize(characterStream,
                               rule: ruleRef,
                               within: streamRange,
                               metadata: rule.metadata)
            while rule.inverted != subtree.absoluteMatch {
                if rule.inverted {
                    let token = Token(rule: rule,
                                      value: stream.firstCharacter,
                                      start: streamRange.location + dx,
                                      length: 1)
                    token.metadata = metadata ?? rule.metadata
                    subtree = GrammarSyntaxScope(scopeClass: .lexerScope)
                    subtree.add(token: token)
                }
                syntaxScope.add(tokens: subtree.tokens)
                matchCount += 1
                dx += subtree.length
                if !rule.quantifier.greedy { break }
                subtree = tokenize(characterStream,
                                   rule: ruleRef,
                                   within: streamRange.shiftingLocation(by: dx),
                                   metadata: rule.metadata)
            }
            
            break
            
        case .composite:
            
            if rule.subrules.count > 0 {
                
                for subrule in rule.subrules {
                    subtree = tokenize(characterStream,
                                       rule: subrule,
                                       within: streamRange,
                                       metadata: metadata)
                    if rule.inverted != subtree.absoluteMatch { break }
                }
                
                while rule.inverted != subtree.absoluteMatch {
                    if rule.inverted {
                        let token = Token(rule: rule,
                                          value: stream.firstCharacter,
                                          start: streamRange.location + dx,
                                          length: 1)
                        token.metadata = metadata ?? rule.metadata
                        subtree = GrammarSyntaxScope(scopeClass: .lexerScope)
                        subtree.add(token: token)
                    }
                    syntaxScope.add(tokens: subtree.tokens)
                    matchCount += 1
                    dx += subtree.length
                    if !rule.quantifier.greedy { break }
                    for subrule in rule.subrules {
                        subtree = tokenize(characterStream,
                                           rule: subrule,
                                           within: streamRange.shiftingLocation(by: dx),
                                           metadata: metadata)
                        if rule.inverted != subtree.absoluteMatch { break }
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
                syntaxScope.add(token: token)
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
                                syntaxScope: syntaxScope,
                                parentScope: parentScope)
            }
            syntaxScope.matches = true
            parentScope?.add(child: syntaxScope)
        }
        
        return syntaxScope
    }
    
}
