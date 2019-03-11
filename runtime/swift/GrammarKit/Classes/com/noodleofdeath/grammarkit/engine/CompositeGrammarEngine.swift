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

import Foundation

/// Grammar engine wrapper class that acts as both a lexer and parser.
@objc(CompositeGrammarEngine)
open class CompositeGrammarEngine: GrammarEngine {
    
    /// Lexer of this compound grammar endine.
    open var lexer: Lexer? {
        didSet { lexer?.delegate = self }
    }
    
    /// Parser of this compound grammar engine.
    open var parser: Parser? {
        didSet { parser?.delegate = self }
    }
    
    override public init(grammar: Grammar, options: Option = []) {
        super.init(grammar: grammar, options: options)
        lexer = Lexer(grammar: grammar)
        lexer?.delegate = self
        parser = Parser(grammar: grammar)
        parser?.delegate = self
    }
    
    ///
    ///
    /// - Parameters:
    ///     - characterStream:
    ///     - offset:
    ///     - length:
    public func tokenize(_ characterStream: CharacterStream?, from offset: Int, length: Int? = nil, parentScope: GrammarSyntaxScope? = nil) {
        lexer?.tokenize(characterStream, from: offset, length: length, parentScope: parentScope)
    }
    
    ///
    ///
    /// - Parameters:
    ///     - characterStream:
    ///     - streamRange:
    public func tokenize(_ characterStream: CharacterStream?, within streamRange: NSRange? = nil, parentScope: GrammarSyntaxScope? = nil) {
        lexer?.tokenize(characterStream, within: streamRange, parentScope: parentScope)
    }
    
    ///
    ///
    /// - Parameters:
    ///     - tokenStream:
    ///     - offset:
    ///     - length:
    public func parse(_ tokenStream: TokenStream?, from offset: Int, length: Int? = nil, parentScope: GrammarSyntaxScope? = nil) {
        parser?.parse(tokenStream, from: offset, length: length, parentScope: parentScope)
    }
    
    ///
    ///
    /// - Parameters:
    ///     - tokenStream:
    ///     - streamRange:
    public func parse(_ tokenStream: TokenStream?, within streamRange: NSRange? = nil, parentScope: GrammarSyntaxScope? = nil) {
        parser?.parse(tokenStream, within: streamRange, parentScope: parentScope)
    }
    
}

// MARK: - GrammarEngineDelegate Methods
extension CompositeGrammarEngine: GrammarEngineDelegate {
    
    @objc
    open func grammarEngine(_ grammarEngine: GrammarEngine, didSkip token: Token, characterStream: CharacterStream, parentScope: GrammarSyntaxScope?) {
        delegate?.grammarEngine?(grammarEngine, didSkip: token, characterStream: characterStream, parentScope: parentScope)
    }
    
    @objc
    open func grammarEngine(_ grammarEngine: GrammarEngine, didGenerate syntaxScope: GrammarSyntaxScope, characterStream: CharacterStream, tokenStream: TokenStream?, parentScope: GrammarSyntaxScope?) {
        delegate?.grammarEngine?(grammarEngine, didGenerate: syntaxScope, characterStream: characterStream, tokenStream: tokenStream, parentScope: parentScope)
    }
    
    @objc
    open func grammarEngine(_ grammarEngine: GrammarEngine, didFinishProcessing characterStream: CharacterStream, tokenStream: TokenStream?, parentScope: GrammarSyntaxScope?) {
        delegate?.grammarEngine?(grammarEngine, didFinishProcessing: characterStream, tokenStream: tokenStream, parentScope: parentScope)
    }
    
}
