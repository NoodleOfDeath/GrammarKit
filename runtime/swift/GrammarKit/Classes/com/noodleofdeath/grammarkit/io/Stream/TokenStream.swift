//
//  GrammarKit
//
//  Copyright © 2019 NoodleOfDeath. All rights reserved.
//

import Foundation

/// Data structure that represents a token stream.
@objc
open class TokenStream: NSObject, Stream {
    
    public typealias Atom = Token
    public typealias AtomSequence = [Token]
    
    open var length: Int { return tokens.count }
    
    /// Tokens contained in this token stream.
    open var tokens = AtomSequence()
    
    /// Character stream from which tokens were derived.
    public let characterStream: CharacterStream
    
    /// Constructs a new token stream with an initial character stream.
    ///
    /// - Parameters:
    ///     - characterStream: of the new token stream.
    public init(characterStream: CharacterStream) {
        self.characterStream = characterStream
    }
    
    open subscript(index: Int) -> Atom {
        return tokens[index]
    }
    
    open subscript(range: Range<Int>) -> AtomSequence {
        var subtokens = AtomSequence()
        for i in range.lowerBound ..< range.upperBound { subtokens.append(tokens[i]) }
        return subtokens
    }
    
    /// Adds a token to this token stream.
    ///
    /// - Parameters:
    ///     - token: to add to this token stream.
    open func add(token: Atom) {
        tokens.append(token)
    }
    
}
