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

/// Specifications for a grammar engine delegate.
public protocol GrammaticalMatcherDelegate: class {
    
    /// Called when a grammar engine skips a token.
    ///
    /// - Parameters:
    ///     - matcher: that called this method.
    ///     - token: that was skipped.
    ///     - characterStream: `matcher` is matching.
    ///     - parentTree: containing all tokenzied/parses information.
    func matcher(_ matcher: GrammaticalMatcher, didSkip token: Token, characterStream: CharacterStream, parentTree: Grammar.SyntaxTree?)
    
    /// Called when a grammar engine generates a syntax.
    /// Overload for `engine(_:didGenerate:characterStream:tokenStream:)`.
    ///
    /// - Parameters:
    ///     - matcher: that called this method.
    ///     - syntaxTree: that was generated.
    ///     - characterStream: `matcher` is matching.
    ///     - tokenStream: generated, or being parsed, by `matcher`.
    ///     - parentTree: containing all tokenzied/parses information.
    func matcher(_ matcher: GrammaticalMatcher, didGenerate syntaxTree: Grammar.SyntaxTree, characterStream: CharacterStream, tokenStream: TokenStream?, parentTree: Grammar.SyntaxTree?)
    
    /// Called when a grammar engine finishes a job.
    /// Overload for `engine(_:didFinishMatching:tokenStream:)`.
    ///
    /// - Parameters:
    ///     - matcher: that called this method.
    ///     - characterStream: `matcher` is matching.
    ///     - tokenStream: generated, or parsed, by `matcher`.
    ///     - parentTree: containing all tokenzied/parses information.
    func matcher(_ matcher: GrammaticalMatcher, didFinishMatching characterStream: CharacterStream, tokenStream: TokenStream?, parentTree: Grammar.SyntaxTree?)
    
}

/// Base abstract class for a grammar matching.
open class GrammaticalMatcher: NSObject {
    
    public typealias Metadata = Grammar.Metadata
    public typealias SyntaxTree = Grammar.SyntaxTree

    /// Delegate of this grammar engine.
    open weak var delegate: GrammaticalMatcherDelegate?
    
    /// Grammar of this engine.
    public let grammar: Grammar
    
    /// Options of this grammar engine.
    open var options: Option = []
    
    /// Constructs a new grammar engine with an initial grammar.
    ///
    /// - Parameters:
    ///     - grammar: to initialize this engine with.
    public init(grammar: Grammar, options: Option = []) {
        self.grammar = grammar
        self.options = options
    }
    
}
