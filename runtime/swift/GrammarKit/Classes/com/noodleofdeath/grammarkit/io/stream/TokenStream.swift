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
