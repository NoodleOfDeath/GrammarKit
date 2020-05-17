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

import Foundation

/// Grammar scanner wrapper class that acts as both a lexer and parser.
open class CompoundGrammaticalScanner: BaseGrammaticalScanner, GrammaticalScannerDelegate {
    
    /// Lexer of this compound grammar endine.
    open var lexer: Lexer? {
        didSet { lexer?.delegate = self }
    }
    
    /// Parser of this compound grammatical scanner.
    open var parser: Parser? {
        didSet { parser?.delegate = self }
    }
    
    override public init(grammar: Grammar) {
        super.init(grammar: grammar)
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
    public func tokenize(_ characterStream: CharacterStream?, from offset: Int, length: Int? = nil, rules: [GrammarRule]? = nil) {
        lexer?.tokenize(characterStream, from: offset, length: length, rules: rules)
    }
    
    ///
    ///
    /// - Parameters:
    ///     - characterStream:
    ///     - streamRange:
    public func tokenize(_ characterStream: CharacterStream?, within streamRange: NSRange? = nil, rules: [GrammarRule]? = nil) {
        lexer?.tokenize(characterStream, within: streamRange, rules: rules)
    }
    
    ///
    ///
    /// - Parameters:
    ///     - tokenStream:
    ///     - offset:
    ///     - length:
    public func parse(_ tokenStream: TokenStream<Token>?, from offset: Int, length: Int? = nil, rules: [GrammarRule]? = nil) {
        parser?.parse(tokenStream, from: offset, length: length, rules: rules)
    }
    
    ///
    ///
    /// - Parameters:
    ///     - tokenStream:
    ///     - streamRange:
    public func parse(_ tokenStream: TokenStream<Token>?, within streamRange: NSRange? = nil, rules: [GrammarRule]? = nil) {
        parser?.parse(tokenStream, within: streamRange, rules: rules)
    }

    // MARK: - GrammaticalScannerDelegate Methods

    open func scanner(_ scanner: GrammaticalScanner, didSkip token: Token, characterStream: CharacterStream) {
        delegate?.scanner(scanner, didSkip: token, characterStream: characterStream)
        handler?.didSkip?(scanner, token, characterStream)
    }

    open func scanner(_ scanner: GrammaticalScanner, didGenerate matchChain: MatchChain, characterStream: CharacterStream, tokenStream: TokenStream<Token>?) {
        delegate?.scanner(scanner, didGenerate: matchChain, characterStream: characterStream, tokenStream: tokenStream)
        handler?.didGenerate?(scanner, matchChain, characterStream, tokenStream)
    }

    open func scanner(_ scanner: GrammaticalScanner, didFinishScanning characterStream: CharacterStream, tokenStream: TokenStream<Token>?) {
        delegate?.scanner(scanner, didFinishScanning: characterStream, tokenStream: tokenStream)
        handler?.didFinish?(scanner, characterStream, tokenStream)
    }
    
}
