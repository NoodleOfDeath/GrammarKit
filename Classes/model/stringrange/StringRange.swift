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

import UIKit

/// Specifications for a string range.
@objc
public protocol StringRangeProtocol: NSObjectProtocol {
    
    /// Start of this string range.
    var start: Int { get set }
    
    /// End of this string range.
    var end: Int { get set }
    
    /// String value contents of the tokens in this string range.
    var string: String { get set }
    
}

extension StringRangeProtocol {
    
    /// Character length of this string range.
    public var length: Int { return end - start }
    
    /// Range of this string range determined from its location index and length.
    public var range: NSRange { return NSMakeRange(start, length) }
    
    public static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.start < rhs.start
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return
            (lhs.string, lhs.start, lhs.end) ==
            (rhs.string, rhs.start, rhs.end)
    }
    
}

/// Base implementation for a `StringRangeProtocol`.
@objc
open class StringRange: NSObject, StringRangeProtocol, Codable {
    
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
    public init(start: Int = 0, length: Int, string: String? = nil) {
        self.start = start
        self.end = start + length
        self.string = string ?? ""
    }
    
}

/// Specifications for a URL resource reference.
@objc
public protocol DocumentReferenceProtocol: StringRangeProtocol {

    /// Document being referenced.
    var document: UIDocument? { get }
    
    /// URL indexed subscopeMap of this scope.
    var urlMap: [URL: DocumentReferenceProtocol] { get }
    
    // MARK: - Instance Properties
    
    /// Mapped subscopes of this string range.
    var stringMap: [Int: DocumentReferenceProtocol] { get }
    
}

extension DocumentReferenceProtocol {
    
    public static func < (lhs: Self, rhs: Self) -> Bool {
        guard lhs.document?.fileURL == rhs.document?.fileURL else { return false }
        return lhs.start < rhs.start
    }
    
}

/// Base implementation for a `DocumentReferenceProtocol`.
@objc
open class DocumentReference: StringRange, DocumentReferenceProtocol, Comparable {
    
    // MARK: - StringRangeProtocol Properties

    // MARK: - Instance Properties

    open var lineNumber: Int = 0

    open var document: UIDocument?
    
    open lazy var urlMap = [URL: DocumentReferenceProtocol]()
    
    // MARK: - Instance Properties
    
    open lazy var stringMap = [Int: DocumentReferenceProtocol]()
    
    /// Cache containing the text contents of this resource.
    open var cachedTextStorage: String?
    
    /// String value contents of the tokens in this string range.
    open var cachedString: String? {
        if cachedTextStorage == nil { updateDerivedTextStorage() }
        return cachedTextStorage?.substring(with: range)
    }
    
    // MARK: - Constructor Methods
    
    /// Constructs a new string range instance with an initial start, length,
    /// and string value.
    ///
    /// - Parameters:
    ///     - start: of the new string range.
    ///     - end: of the new string range.
    ///     - string: value of the new string range.
    public convenience init <DocumentType: UIDocument>(document: DocumentType? = nil, start: Int = 0, lineNumber: Int = 0, end: Int = 0, string: String? = nil, urlMap: [URL: DocumentReferenceProtocol]? = nil) {
        self.init()
        self.document = document
        self.start = start
        self.lineNumber = lineNumber
        self.end = end
        self.string = string ?? ""
        self.urlMap = urlMap ?? [:]
    }
    
    /// Constructs a new string range instance with an initial start, length,
    /// and string value.
    ///
    /// - Parameters:
    ///     - url: of this new scope.
    ///     - start: of the new scope.
    ///     - length: of the new scope.
    ///     - string: value of the new scope.
    public convenience init <DocumentType: UIDocument>(document: DocumentType? = nil, start: Int = 0, lineNumber: Int = 0, length: Int, string: String? = nil, urlMap: [URL: DocumentReferenceProtocol]? = nil) {
        self.init()
        self.document = document
        self.start = start
        self.lineNumber = lineNumber
        self.end = start + length
        self.string = string ?? ""
        self.urlMap = urlMap ?? [:]
    }
    
    // MARK: - Instance Methods
    
    open subscript (key: URL) -> DocumentReferenceProtocol? {
        get { return urlMap[key] }
        set { urlMap[key] = newValue }
    }
    
    open subscript (index: Int) -> DocumentReferenceProtocol {
        get { return self }
        set {
            
        }
    }
    
    open func updateDerivedTextStorage() {
        guard let document = document else { return }
        cachedTextStorage = try? String(contentsOf: document.fileURL)
    }
    
    open func clearDerivedTextStorage() {
        cachedTextStorage = nil
    }
    
}


