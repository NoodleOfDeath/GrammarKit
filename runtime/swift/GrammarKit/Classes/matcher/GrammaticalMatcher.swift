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

@objc
public protocol GrammaticalMatcher: class {

    typealias CharacterStream = IO.CharacterStream
    typealias TokenStream = IO.TokenStream
    typealias Token = Grammar.Token

    typealias Metadata = Grammar.Metadata
    typealias MatchChain = Grammar.MatchChain

}

/// Specifications for a grammar matcher delegate.
public protocol GrammaticalMatcherDelegate: class {

    typealias CharacterStream = IO.CharacterStream
    typealias TokenStream = IO.TokenStream
    typealias Token = Grammar.Token

    typealias Metadata = Grammar.Metadata
    typealias MatchChain = Grammar.MatchChain
    
    /// Called when a grammar matcher skips a token.
    ///
    /// - Parameters:
    ///     - matcher: that called this method.
    ///     - token: that was skipped.
    ///     - characterStream: `matcher` is matching.
    func matcher(_ matcher: GrammaticalMatcher, didSkip token: Token, characterStream: CharacterStream)
    
    /// Called when a grammar matcher generates a match chain.
    ///
    /// - Parameters:
    ///     - matcher: that called this method.
    ///     - matchChain: that was generated.
    ///     - characterStream: `matcher` is matching.
    ///     - tokenStream: generated, or being parsed, by `matcher`.
    func matcher(_ matcher: GrammaticalMatcher, didGenerate matchChain: MatchChain, characterStream: CharacterStream, tokenStream: TokenStream<Token>?)
    
    /// Called when a grammar matcher finishes a job.
    ///
    /// - Parameters:
    ///     - matcher: that called this method.
    ///     - characterStream: `matcher` is matching.
    ///     - tokenStream: generated, or parsed, by `matcher`.
    func matcher(_ matcher: GrammaticalMatcher, didFinishMatching characterStream: CharacterStream, tokenStream: TokenStream<Token>?)
    
}


/// Base abstract class for a grammar matching.
open class BaseGrammaticalMatcher: NSObject, GrammaticalMatcher {

    /// Delegate of this grammar matcher.
    open weak var delegate: GrammaticalMatcherDelegate?
    
    /// Grammar of this matcher.
    public let grammar: Grammar
    
    /// Constructs a new grammar matcher with an initial grammar.
    ///
    /// - Parameters:
    ///     - grammar: to initialize this matcher with.
    public init(grammar: Grammar) {
        self.grammar = grammar
    }
    
}
