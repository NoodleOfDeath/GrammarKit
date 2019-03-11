//
//  GrammarKit
//
//  Copyright © 2019 NoodleOfDeath. All rights reserved.
//

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
