//
//  GrammarKit
//
//  Copyright © 2019 NoodleOfDeath. All rights reserved.
//

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
