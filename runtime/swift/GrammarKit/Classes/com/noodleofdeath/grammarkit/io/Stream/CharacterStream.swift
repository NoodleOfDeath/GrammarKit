//
//  PastaParser
//
//  Copyright © 2019 NoodleOfDeath. All rights reserved.
//

/// Data structure for a character stream.
@objc(CharacterStream)
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
