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

/// Specifications for a grammar engine delegate.
@objc
public protocol GrammarEngineDelegate: class {
    
    /// Called when a grammar engine skips a token.
    ///
    /// - Parameters:
    ///     - grammarEngine: that called this method.
    ///     - token: that was skipped.
    ///     - characterStream: `grammarEngine` is processing.
    ///     - parentScope: containing all tokenzied/parses information.
    @objc optional
    func grammarEngine(_ grammarEngine: GrammarEngine, didSkip token: Token, characterStream: CharacterStream, parentScope: GrammarSyntaxScope?)
    
    /// Called when a grammar engine generates a syntax tree.
    /// Overload for `engine(_:didGenerate:characterStream:tokenStream:)`.
    ///
    /// - Parameters:
    ///     - grammarEngine: that called this method.
    ///     - syntaxScope: that was generated.
    ///     - characterStream: `grammarEngine` is processing.
    ///     - tokenStream: generated, or being parsed, by `grammarEngine`.
    ///     - parentScope: containing all tokenzied/parses information.
    @objc optional
    func grammarEngine(_ grammarEngine: GrammarEngine, didGenerate syntaxScope: GrammarSyntaxScope, characterStream: CharacterStream, tokenStream: TokenStream?, parentScope: GrammarSyntaxScope?)
    
    /// Called when a grammar engine finishes a job.
    /// Overload for `engine(_:didFinishProcessing:tokenStream:)`.
    ///
    /// - Parameters:
    ///     - grammarEngine: that called this method.
    ///     - characterStream: `grammarEngine` is processing.
    ///     - tokenStream: generated, or parsed, by `grammarEngine`.
    ///     - parentScope: containing all tokenzied/parses information.
    @objc optional
    func grammarEngine(_ grammarEngine: GrammarEngine, didFinishProcessing characterStream: CharacterStream, tokenStream: TokenStream?, parentScope: GrammarSyntaxScope?)
    
}

/// Base abstract class for a grammar processing engine.
@objc
open class GrammarEngine: NSObject {

    /// Delegate of this grammar engine.
    open weak var delegate: GrammarEngineDelegate?
    
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
