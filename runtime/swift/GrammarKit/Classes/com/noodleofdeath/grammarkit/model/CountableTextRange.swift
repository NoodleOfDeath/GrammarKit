//
//  GrammarKit
//
//  Copyright © 2019 NoodleOfDeath. All rights reserved.
//

import Foundation

@objc
open class CountableTextPosition: UITextPosition, Codable {
    
    public let location: Int
    
    public init(location: Int = 0) {
        self.location = location
    }
    
}

@objc
open class CountableTextRange: UITextRange, Codable {
    
    ///
    fileprivate var _start: CountableTextPosition
    
    ///
    fileprivate var _end: CountableTextPosition
    
    override open var start: CountableTextPosition {
        return _start
    }
    
    override open var end: CountableTextPosition {
        return _end
    }
    
    /// Character length of this text range.
    open var length: Int { return range.length }
    
    /// Range of this text range determined from its location index and length.
    open var range: NSRange { return range(from: start, to: end) }
    
    /// String value contents of the tokens in this text range.
    open var string: String
    
    ///
    open func range(from start: CountableTextPosition, to end: CountableTextPosition) -> NSRange {
        return NSMakeRange(start.location, end.location - start.location)
    }
    
    ///
    public init(start: CountableTextPosition? = nil, end: CountableTextPosition? = nil, string: String? = nil) {
        _start = start ?? CountableTextPosition()
        _end = end ?? CountableTextPosition()
        self.string = string ?? ""
    }
    
    ///
    public init(start: Int, length: Int, string: String? = nil) {
        _start = CountableTextPosition(location: start)
        _end = CountableTextPosition(location: start + length)
        self.string = string ?? ""
    }
    
    ///
    public func set(start: CountableTextPosition) {
        _start = start
    }
    
    ///
    public func set(start: Int) {
        _start = CountableTextPosition(location: start)
    }
    
    ///
    public func set(length: Int) {
        _end = CountableTextPosition(location: start.location + length)
    }
    
    ///
    public func set(end: CountableTextPosition) {
        _end = end
    }
    
    ///
    public func set(end: Int) {
        _end = CountableTextPosition(location: end)
    }
    
    ///
    public func set(string: String?) {
        self.string = string ?? ""
    }
    
}

@objc
open class URLTextRange: CountableTextRange {
    
    /// Resource that contains this text range.
    open var url: URL?
    
    ///
    fileprivate var derivedTextStorage: String?
    
    /// String value contents of the tokens in this text range.
    open var derivedString: String? {
        if derivedTextStorage == nil { updateDerivedTextStorage() }
        return derivedTextStorage?.substring(with: range)
    }
    
    open func updateDerivedTextStorage() {
        guard let url = url else { return }
        derivedTextStorage = try? String(contentsOf: url)
    }
    
    open func clearDerivedTextStorage() {
        derivedTextStorage = nil
    }
    
}

