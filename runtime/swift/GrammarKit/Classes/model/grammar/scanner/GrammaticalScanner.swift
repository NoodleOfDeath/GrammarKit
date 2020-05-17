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
public protocol GrammaticalScanner: class {

    typealias CharacterStream = IO.CharacterStream
    typealias TokenStream = IO.TokenStream
    typealias Token = Grammar.Token

    typealias Metadata = Grammar.Metadata
    typealias MatchChain = Grammar.MatchChain

}

/// Specifications for a grammatical scanner delegate.
public protocol GrammaticalScannerDelegate: class {

    typealias CharacterStream = IO.CharacterStream
    typealias TokenStream = IO.TokenStream
    typealias Token = Grammar.Token

    typealias Metadata = Grammar.Metadata
    typealias MatchChain = Grammar.MatchChain
    
    /// Called when a grammatical scanner skips a token.
    ///
    /// - Parameters:
    ///     - scanner: that called this method.
    ///     - token: that was skipped.
    ///     - characterStream: `scanner` is scanning.
    func scanner(_ scanner: GrammaticalScanner, didSkip token: Token, characterStream: CharacterStream)
    
    /// Called when a grammatical scanner generates a match chain.
    ///
    /// - Parameters:
    ///     - scanner: that called this method.
    ///     - matchChain: that was generated.
    ///     - characterStream: `scanner` is scanning.
    ///     - tokenStream: generated, or being parsed, by `scanner`.
    func scanner(_ scanner: GrammaticalScanner, didGenerate matchChain: MatchChain, characterStream: CharacterStream, tokenStream: TokenStream<Token>?)
    
    /// Called when a grammatical scanner finishes a job.
    ///
    /// - Parameters:
    ///     - scanner: that called this method.
    ///     - characterStream: `scanner` is scanning.
    ///     - tokenStream: generated, or parsed, by `scanner`.
    func scanner(_ scanner: GrammaticalScanner, didFinishScanning characterStream: CharacterStream, tokenStream: TokenStream<Token>?)
    
}


/// Base abstract class for a grammar scanning.
open class BaseGrammaticalScanner: NSObject, GrammaticalScanner {

    /// Delegate of this grammatical scanner.
    open weak var delegate: GrammaticalScannerDelegate?

    /// Handler of this grammartical scanner.
    open var handler: GrammaticalScannerHandler?

    open var didSkip: ((_ scanner: GrammaticalScanner, _ token: Grammar.Token, _ characterStream: IO.CharacterStream) -> ())? {
        get { return handler?.didSkip }
        set {
            if handler == nil { handler = GrammaticalScannerHandler() }
            handler?.didSkip = newValue
        }
    }

    open var didGenerate: ((_ scanner: GrammaticalScanner, _ matchChain: Grammar.MatchChain, _ characterStream: IO.CharacterStream, _ tokenStream: IO.TokenStream<Grammar.Token>?) -> ())? {
        get { return handler?.didGenerate }
        set {
            if handler == nil { handler = GrammaticalScannerHandler() }
            handler?.didGenerate = newValue
        }
    }

    open var didFinish: ((_ scanner: GrammaticalScanner, _ characterStream: IO.CharacterStream, _ tokenStream: IO.TokenStream<Grammar.Token>?) -> ())? {
        get { return handler?.didFinish }
        set {
            if handler == nil { handler = GrammaticalScannerHandler() }
            handler?.didFinish = newValue
        }
    }
    
    /// Grammar of this scanner.
    public let grammar: Grammar
    
    /// Constructs a new grammatical scanner with an initial grammar.
    ///
    /// - Parameters:
    ///     - grammar: to initialize this scanner with.
    public init(grammar: Grammar) {
        self.grammar = grammar
    }
    
}

/// Data structure representing a grammatical scanner handler alternative
/// to a `GrammaticalScannerDelegate`.
public struct GrammaticalScannerHandler {
    var didSkip: ((_ scanner: GrammaticalScanner, _ token: Grammar.Token, _ characterStream: IO.CharacterStream) -> ())?
    var didGenerate: ((_ scanner: GrammaticalScanner, _ matchChain: Grammar.MatchChain, _ characterStream: IO.CharacterStream, IO.TokenStream<Grammar.Token>?) -> ())?
    var didFinish: ((_ scanner: GrammaticalScanner, _ characterStream: IO.CharacterStream, _ tokenStream: IO.TokenStream<Grammar.Token>?) -> ())?
}
