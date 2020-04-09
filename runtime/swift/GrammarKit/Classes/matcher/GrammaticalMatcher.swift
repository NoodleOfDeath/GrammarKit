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

    typealias Metadata = Grammar.Metadata
    typealias SyntaxTree = Grammar.SyntaxTree

}

/// Specifications for a grammar matcher delegate.
public protocol GrammaticalMatcherDelegate: class {
    
    /// Called when a grammar matcher skips a token.
    ///
    /// - Parameters:
    ///     - matcher: that called this method.
    ///     - token: that was skipped.
    ///     - characterStream: `matcher` is matching.
    ///     - parentTree: containing all tokenzied/parses information.
    func matcher(_ matcher: GrammaticalMatcher, didSkip token: Token, characterStream: CharacterStream, parentTree: Grammar.SyntaxTree?)
    
    /// Called when a grammar matcher generates a syntax.
    /// Overload for `matcher(_:didGenerate:characterStream:tokenStream:)`.
    ///
    /// - Parameters:
    ///     - matcher: that called this method.
    ///     - syntaxTree: that was generated.
    ///     - characterStream: `matcher` is matching.
    ///     - tokenStream: generated, or being parsed, by `matcher`.
    ///     - parentTree: containing all tokenzied/parses information.
    func matcher(_ matcher: GrammaticalMatcher, didGenerate syntaxTree: Grammar.SyntaxTree, characterStream: CharacterStream, tokenStream: TokenStream?, parentTree: Grammar.SyntaxTree?)
    
    /// Called when a grammar matcher finishes a job.
    /// Overload for `matcher(_:didFinishMatching:tokenStream:)`.
    ///
    /// - Parameters:
    ///     - matcher: that called this method.
    ///     - characterStream: `matcher` is matching.
    ///     - tokenStream: generated, or parsed, by `matcher`.
    ///     - parentTree: containing all tokenzied/parses information.
    func matcher(_ matcher: GrammaticalMatcher, didFinishMatching characterStream: CharacterStream, tokenStream: TokenStream?, parentTree: Grammar.SyntaxTree?)
    
}


/// Base abstract class for a grammar matching.
open class BaseGrammaticalMatcher: NSObject, GrammaticalMatcher {

    /// Delegate of this grammar matcher.
    open weak var delegate: GrammaticalMatcherDelegate?
    
    /// Grammar of this matcher.
    public let grammar: Grammar
    
    /// Options of this grammar matcher.
    open var options: GrammaticalMatcherOption = []
    
    /// Constructs a new grammar matcher with an initial grammar.
    ///
    /// - Parameters:
    ///     - grammar: to initialize this matcher with.
    public init(grammar: Grammar, options: GrammaticalMatcherOption = []) {
        self.grammar = grammar
        self.options = options
    }
    
}
