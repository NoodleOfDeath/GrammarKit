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

import Foundation

/// Specifications for a string range.
public protocol StringRangeProtocol: Comparable, Codable {
    
    /// Start of this string range.
    var start: Int { get set }
    
    /// End of this string range.
    var end: Int { get set }
    
    /// String value contents of the tokens in this string range.
    var string: String { get set }
    
}

extension StringRangeProtocol {

    // MARK: - Instance Properties

    /// Character length of this string range.
    public var length: Int { return end - start }
    
    /// Range of this string range determined from its location index and length.
    public var range: NSRange { return NSMakeRange(start, length) }
    
}

/// Base implementation for a `StringRangeProtocol`.
open class StringRange: NSObject, StringRangeProtocol {

    // MARK: - StringRangeProtocol Properties
    
    open var start: Int
    
    open var end: Int
    
    open var string: String
    
    // MARK: - Constructor Methods
    
    /// Constructs a new string range instance with an initial start, length,
    /// and string value.
    ///
    /// - Parameters:
    ///     - start: of the new string range.
    ///     - end: of the new string range.
    ///     - string: value of the new string range.
    public init(start: Int = 0, end: Int = 0, string: String? = nil) {
        self.start = start
        self.end = end
        self.string = string ?? ""
    }
    
    /// Constructs a new string range instance with an initial start, length,
    /// and string value.
    ///
    /// - Parameters:
    ///     - start: of the new string range.
    ///     - length: of the new string range.
    ///     - string: value of the new string range.
    public convenience init(start: Int = 0, length: Int, string: String? = nil) {
        self.init(start: start, end: start + length, string: string)
    }

    // MARK: - Comparable Methods

    public static func < (lhs: StringRange, rhs: StringRange) -> Bool {
        return lhs.start < rhs.start
    }

    // MARK: - Equatable Methods

    public static func == (lhs: StringRange, rhs: StringRange) -> Bool {
        return (lhs.start, lhs.end, lhs.string) == (rhs.start, rhs.end, rhs.string)
    }
    
}

