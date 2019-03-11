//
//  PastaParser
//
//  Copyright © 2019 NoodleOfDeath. All rights reserved.
//

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
