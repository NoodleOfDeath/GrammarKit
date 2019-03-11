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

/// Specifications for a stream that is composed of a sequence of atoms.
public protocol Stream {
    
    /// Smallest singular unit type of this stream.
    associatedtype Atom: Any
    
    /// Type representation for a sequence of atoms contained in this stream.
    associatedtype AtomSequence: Any
    
    /// Total number of atoms in this stream.
    var length: Int { get }
    
    /// Returns the atom of this stream at a specified index.
    ///
    /// - Parameters:
    ///     - index: of the atom to return.
    /// - Returns: the atom of this stream at `index`.
    subscript(index: Int) -> Atom { get }
    
    /// Returns a subrange of atoms in this stream.
    ///
    /// - Parameters:
    ///     - range: of the subset of atom to return.
    /// - Returns: a subset of atoms in this stream spanning `range`.
    subscript(range: Range<Int>) -> AtomSequence { get }
    
}

extension Stream {
    
    /// Range of this stream.
    /// Shorthand for `NSMakeRange(0, length)`.
    public var range: NSRange { return NSMakeRange(0, length) }

    /// Returns a subrange of atoms in this stream.
    ///
    /// - Parameters:
    ///     - range: of the subset of atom to return.
    /// - Returns: a subset of atoms in this stream spanning `range`.
    public subscript(range: NSRange) -> AtomSequence {
        return self[range.bridgedRange]
    }
    
}
