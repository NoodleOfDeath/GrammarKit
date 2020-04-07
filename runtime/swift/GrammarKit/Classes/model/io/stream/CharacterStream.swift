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

/// Data structure for a character stream.
open class CharacterStream: NSObject, Stream {
    
    public typealias Atom = String
    public typealias AtomSequence = String
    
    open var length: Int { return string?.length ?? 0 }
    
    /// Source of this character stream.
    open var source: Any?
    
    /// Block that derives the value of the string value of this character
    /// stream.
    open lazy var derivation: ((Any?) -> AtomSequence?) = { $0 as? AtomSequence }
    
    /// Derived string value of this character stream.
    open var string: AtomSequence? { return derivation(source) }
    
    /// Constructs a new instance of a character stream with an initial source
    /// and derivation block.
    public init(_ source: Any?, _ derivation: ((Any?) -> AtomSequence?)? = nil) {
        super.init()
        self.source = source
        self.derivation ?= derivation
    }
    
    open subscript (index: Int) -> Atom {
        guard let string = string else { return "" }
        return string.char(at: index)
    }
    
    open subscript(range: Range<Int>) -> AtomSequence {
        guard let string = string else { return "" }
        return string[range]
    }
    
}
