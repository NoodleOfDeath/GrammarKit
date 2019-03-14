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

import CoreImage
import UIKit

// This file contains usefult local extensions accessible only to this module.
// You may modify this file and the scope of various extensions as needed
// for personal projects, but not when committing to the repository.

// MARK: - Path Component Concatentation Infix Operator

infix operator +/ : AdditionPrecedence

// MARK: - Optional Assignment Operator

infix operator ?= : AssignmentPrecedence

// MARK: - Exponentiation Infix Operator

precedencegroup ExponentiationPrecedence {
    associativity: right
    higherThan: MultiplicationPrecedence
}

infix operator ** : ExponentiationPrecedence

// MARK: - Optional Wrapper Assignment Operator Methods

///
///
/// - Parameters:
///     - lhs:
///     - rhs:
func ?= <T>(lhs: inout T, rhs: T?) {
    guard let rhs = rhs else { return }
    lhs = rhs
}

///
///
/// - Parameters:
///     - lhs:
///     - rhs:
func ?= <T>(lhs: inout T?, rhs: T?) {
    guard let rhs = rhs else { return }
    lhs = rhs
}

// MARK: - Exponentiation Operator Methods

/// Exponential power operation.
///
/// - Parameters:
///     - base: of this power operation.
///     - exp: to raise the base to.
/// - Returns: `base` raised to the power of `exp`.
func ** (base: Double, exp: Double) -> Double {
    return pow(base, exp)
}

// MARK: - Numeric-Boolean Math Operator Methods

///
///
/// - Parameters:
///     - lhs:
///     - rhs:
/// - Returns:
func + <NumericType: Numeric>(lhs: NumericType, rhs: Bool) -> NumericType {
    return lhs + (rhs ? 1 : 0)
}

///
///
/// - Parameters:
///     - lhs:
///     - rhs:
/// - Returns:
func + <NumericType: Numeric>(lhs: Bool, rhs: NumericType) -> NumericType {
    return (lhs ? 1 : 0) + rhs
}

// MARK: - CGFloat Extensions
extension CGFloat {
    
    /// Legacy alias for `leastNormalMagnitude`.
    static var min: CGFloat {  return leastNormalMagnitude }
    
    /// Legacy alias for `greatestFiniteMagnitude`.
    static var max: CGFloat { return greatestFiniteMagnitude }
    
}

// MARK: - CGRect Extensions
extension CGRect {
    
    /// x-coordinate of this rect.
    var x: CGFloat {
        get { return origin.x }
        set { origin.x = newValue }
    }
    
    /// y-coordinate of this rect.
    var y: CGFloat {
        get { return origin.y }
        set { origin.y = newValue }
    }
    
    /// width of this rect.
    var width: CGFloat {
        get { return size.width }
        set { size.width = newValue }
    }
    
    /// height of this rect.
    var height: CGFloat {
        get { return size.height }
        set { size.width = newValue }
    }
    
    /// Offset width of this view. Returns `x + width`.
    var offsetWidth: CGFloat {
        return x + width
    }
    
    /// Offset height of this view. Returns `y + height`.
    var offsetHeight: CGFloat {
        return y + height
    }
    
}

// MARK: - CGSize Extensions
extension CGSize {
    
    static var zero: CGSize { return CGSize(width: 0, height: 0) }
    
    static var max: CGSize { return CGSize(width: .max, height: .max) }
    
    ///
    struct Key: BaseRawRepresentable {
        
        typealias This = Key
        typealias RawValue = String
        
        let rawValue: RawValue
        
        // MARK: - Static Properties
        
        static let width = Key(rawValue: "width")
        static let height = Key(rawValue: "height")
        
        // MARK: - Constructor Methods
        
        init(rawValue: RawValue) {
            self.rawValue = rawValue
        }
        
    }
    
    ///
    static func * (lhs: CGSize, rhs: CGFloat) -> CGSize {
        return CGSize(width: lhs.width * rhs, height: lhs.width * rhs)
    }
    
    ///
    static func / (lhs: CGSize, rhs: CGFloat) -> CGSize {
        return CGSize(width: lhs.width / rhs, height: lhs.width / rhs)
    }
    
    ///
    static func * (lhs: CGFloat, rhs: CGSize) -> CGSize {
        return rhs * lhs
    }
    
    ///
    static func / (lhs: CGFloat, rhs: CGSize) -> CGSize {
        return rhs / lhs
    }
    
}

// MARK: - Date Extensions
extension Date {
    
    /// Formats this date into a string using a specified format, data style,
    /// time style, and locale.
    ///
    /// - Parameters:
    ///     - dateFormat: to format this date with.
    ///     - dateStyle: to format the date portion of this date with.
    ///     - timeStyle: to format the time portion of this date with.
    ///     - locale: to format this date with.
    /// - Returns: this date as a string using a specified format, data style,
    /// time style, and locale.
    func string(withFormat dateFormat: String = "MM/dd/yyyy HH:mm A", dateStyle: DateFormatter.Style = .short, timeStyle: DateFormatter.Style = .short, locale: Locale = .current) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = dateStyle
        formatter.timeStyle = timeStyle
        formatter.locale = locale
        return formatter.string(from: self)
    }
    
}

// MARK: NSAttributeString Property Extensions
extension NSAttributedString {
    
    /// Range of this attributed string.
    /// Shorthand for `string.range`.
    var range: NSRange { return string.range }
    
}

// MARK: - NSRange Extensions
extension NSRange {
    
    /// A range with location and length set to `0`.
    static var zero: NSRange { return NSMakeRange(0, 0) }
    
    /// Any range with a negative length is invalid.
    static var invalid: NSRange { return NSMakeRange(0, -1) }
    
    /// Returns the sum of the `location` and `length` of this range.
    /// Shorthand for `NSMaxRange(self)`.
    var max: Int { return NSMaxRange(self) }
    
    /// Range struct representatin of this range.
    var bridgedRange: Range<Int> { return location ..< max }
    
    /// Returns `true` if, and only if, `length > -1`.
    var valid: Bool { return length > -1 }
    
}

// MARK: - NSRange Shifting Extensions
extension NSRange {
    
    /// Shifts a range location and length by a specified integer tuple.
    ///
    /// - Parameters:
    ///     - lhs: range to shift.
    ///     - rhs: tuple to shift the location and length of `lhs` by.
    /// - Returns: a range with a location equal to
    /// `lhs.location + rhs.location` and length equal to
    /// `lhs.length + rhs.length`.
    static func + (lhs: NSRange, rhs: (location: Int, length: Int)) -> NSRange {
        return NSMakeRange(lhs.location + rhs.location, lhs.length + rhs.length)
    }
    
    /// Shifts the location of this range by a specified offset and adjusts
    /// its length to have the same end index, unless `true` is passed for
    /// `keepLength`.
    ///
    /// - Parameters:
    ///     - offset: to shift the location of this range by.
    ///     - keepLength: specify `true` to indicate the length of this range
    /// should remain unchanged; specfiy `false`, to indicate that the length
    /// should be adjusted to maintain the same `max` value. Default value
    /// is `false`.
    mutating func shiftLocation(by offset: Int, keepLength: Bool = false) {
        location += offset
        length = keepLength ? length : Swift.max(length - offset, 0)
    }
    
    /// Returns a copy of this range with the location shifted by a specified
    /// offset and the length adjusted to have the same end index as this range,
    /// unless `true` is passed for `keepLength`.
    ///
    /// - Parameters:
    ///     - offset: to shift the location of the range by relative to the
    /// location of this range.
    ///     - keepLength: specify `true` to indicate the length of the returned
    /// range should be equal to the range of this range; specify `false`, to
    /// indicate that the length should be adjusted to maintain the same `max`
    /// value of this range. Default value is `false`.
    /// - Returns: a copy of this range with the location shifted by a specified
    /// offset and the length adjusted to have the same end index as this range,
    /// unless `true` is passed for `keepLength`.
    func shiftingLocation(by offset: Int, keepLength: Bool = false) -> NSRange {
        return NSMakeRange(location + offset, keepLength ? length : Swift.max(length - offset, 0))
    }
    
    /// Contracts this range at both ends by a specified width. The result
    /// leaves this range with a postive, or zero, length that equal to
    /// `oldLength - (width * 2)` and a location equal to `length + width`.
    ///
    /// - Parameters:
    ///     - width: to contract this range by.
    mutating func contract(by width: Int) {
        location += width
        length = Swift.max(length - (width * 2), 0)
    }
    
    /// Expands this range at both ends by a specified width. The result
    /// leaves this range with a postive, or zero, length that equal to
    /// `oldLength + (width * 2)` and a location equal to `length - width`.
    ///
    /// - Parameters:
    ///     - width: to expand this range by.
    mutating func expand(by width: Int) {
        location -= width
        length += (width * 2)
    }
    
    /// Returns a copy of this range that is contracted at both ends by a
    /// specified width. The resultant range will have a postive, or zero,
    /// length that equal to `oldLength - (width * 2)` and a location equal
    /// to `length + width`.
    ///
    /// - Parameters:
    ///     - width: to contract this range by.
    /// - Returns: a copy of this range that has been contracted at both ends
    /// by `width`.
    func contracted(by width: Int) -> NSRange {
        return NSMakeRange(location + width, Swift.max(length - (width * 2), 0))
    }
    
    /// Returns a copy of this range that is expanded at both ends by a
    /// specified width. The resultant range will have a postive, or zero,
    /// length that equal to `oldLength + (width * 2)` and a location equal
    /// to `length - width`.
    /// - Parameters:
    ///     - width: to contract this range by.
    /// - Returns: a copy of this range that has been expanded at both ends
    /// by `width`.
    func expanded(by width: Int) -> NSRange {
        return NSMakeRange(location - width, length + (width * 2))
    }
    
}

// MARK: - NSShadow Extensions
extension NSShadow {
    
    /// UI type casted color of this shadow.
    var color: UIColor? {
        get { return shadowColor as? UIColor }
        set { shadowColor = newValue }
    }
    
    /// CG type casted color of this shadow.
    var cgColor: CGColor? {
        get { return color?.cgColor }
        set {
            guard let cgColor = newValue else { color = nil; return }
            color = UIColor(cgColor: cgColor)
        }
    }
    
}

// MARK: - Range Property Extensions
extension Range where Bound == Int {
    
    /// Length of this range.
    var length: Bound { return upperBound - lowerBound }
    
    /// NSRange representation of this range.
    var bridgedRange: NSRange { return NSMakeRange(lowerBound, length) }
    
}

///
struct StringFormattingOption: BaseOptionSet {
    
    typealias This = StringFormattingOption
    typealias RawValue = Int
    
    static let escaped = This(1 << 0)
    
    static let stripOuterBraces = This(1 << 1)
    
    static let stripOuterBrackets = This(1 << 2)
    
    static let stripOuterParentheses = This(1 << 3)
    
    static let truncate = This(1 << 4)
    
    let rawValue: RawValue
    
    init(rawValue: RawValue) {
        self.rawValue = rawValue
    }
    
}

// MARK: - String Property Extensions (NSString Bridging Properties)
extension String {
    
    /// This string casted as a `NSString`.
    /// Shorthand for `(self as NSString)`.
    var ns: NSString { return self as NSString }
    
    /// Actual length of this string in terms of number of bytes.
    /// Shorthand for `(self as NSString).length`.
    var length: Int { return ns.length }
    
    /// Zero based range of this string.
    /// Shorthand for `NSMakeRange(0, length)`.
    var range: NSRange { return NSMakeRange(0, length) }
    
    func range(offsetBy offset: Int) -> NSRange { return NSMakeRange(offset, length - offset) }
    
    /// First letter of this string; or an empty string if this string is empty.
    var firstCharacter: String { return length > 0 ? substring(to: 1) : "" }
    
    /// Last letter of this string; or an empty string if this string is empty.
    var lastCharacter: String { return length > 0 ? substring(from: length - 1) : "" }
    
    /// Returns `true` if the first letter of this string is capitalized.
    /// An empty string will return `false`.
    var isCapitalized: Bool { return length > 0 && firstCharacter == firstCharacter.uppercased() }
    
    /// Returns `true` if this entire string is uppercased.
    /// An empty string will return `false`.
    var isUppercased: Bool { return length > 0 && self == uppercased() }
    
    /// Returns `true` if this entire string is lowercased.
    /// An empty string will return `false`.
    var isLowercased: Bool { return length > 0 && self == lowercased() }
    
    /// Last path component of this string.
    /// Shorthand for `(self as NSString).lastPathComponent`.
    var lastPathComponent: String { return ns.lastPathComponent }
    
    /// Path extension of this string.
    /// Shorthand for `(self as NSString).pathExtension`.
    var pathExtension: String { return ns.pathExtension }
    
    /// This string with the last path component removed.
    /// Shorthand for `(self as NSString).deletingLastPathComponent`.
    var deletingLastPathComponent: String { return ns.deletingLastPathComponent }
    
    /// This string with the path extension removed.
    /// Shorthand for `(self as NSString).deletingPathExtension`.
    var deletingPathExtension: String { return ns.deletingPathExtension }
    
    /// Number of lines contained in this string.
    var lineCount: Int { return components(separatedBy: .newlines).count }
    
    /// Number of lines contained in this string.
    var wordCount: Int { return components(separatedBy: .whitespacesAndNewlines).count }
    
    /// File URL instance that uses this string as the file URL path.
    /// Shorthand for `URL(fileURLWithPath: self)`.
    var fileURL: URL { return URL(fileURLWithPath: self) }
    
}

// MARK: - String Method Extensions (NSString Bridging Methods)
extension String {
    
    /// Returns a new string containing the characters of the receiver up to,
    /// but not including, the one at a given index.
    ///
    /// - Parameters:
    ///     - index: An index. The value must lie within the bounds
    /// of the receiver, or be equal to the length of the receiver.
    /// Raises an rangeException if (anIndex - 1) lies beyond the end of the
    /// receiver.
    /// - Returns: A new string containing the characters of the receiver up
    /// to, but not including, the one at anIndex. If anIndex is equal to the
    /// length of the string, returns a copy of the receiver.
    func substring(to index: Int) -> String {
        return ns.substring(to: index)
    }
    
    /// Returns a new string containing the characters of the receiver up to,
    /// but not including, the one at a given index.
    ///
    /// - Parameters:
    ///     - index: An index. The value must lie within the bounds of
    /// the receiver, or be equal to the length of the receiver.
    /// Raises an rangeException if (anIndex - 1) lies beyond the end of the
    /// receiver.
    /// - Returns: A new string containing the characters of the receiver from
    /// the one at anIndex to the end. If anIndex is equal to the length of the
    /// string, returns an empty string.
    func substring(from index: Int) -> String {
        return ns.substring(from: index)
    }
    
    ///
    /// - Parameters:
    ///     - range: A range. The range must not exceed the bounds of the
    /// receiver. Raises an rangeException if `(aRange.location - 1)` or
    /// `(aRange.location + aRange.length - 1)` lies beyond the end of the
    /// receiver.
    /// - Returns: A string object containing the characters of the receiver
    /// that lie within `range`.
    func substring(with range: NSRange) -> String {
        return ns.substring(with: range)
    }
    
    ///
    /// - Parameters:
    ///     - range: A range. The range must not exceed the bounds of the
    /// receiver. Raises an rangeException if `(aRange.location - 1)` or
    /// `(aRange.location + aRange.length - 1)` lies beyond the end of the
    /// receiver.
    /// - Returns: A string object containing the characters of the receiver
    /// that lie within `range`.
    func substring(with range: Range<Int>) -> String {
        return ns.substring(with: range.bridgedRange)
    }
    
    ///
    /// - Parameters:
    ///     - range: A range. The range must not exceed the bounds of the
    /// receiver. Raises an rangeException if `(aRange.location - 1)` or
    /// `(aRange.location + aRange.length - 1)` lies beyond the end of the
    /// receiver.
    /// - Returns: A string object containing the characters of the receiver
    /// that lie within `range`.
    subscript (range: Range<Int>) -> String {
        return ns.substring(with: range.bridgedRange)
    }
    
    ///
    /// - parameter anIndex:
    /// - Returns:
    func char(at anIndex: Int) -> String {
        return substring(with: NSMakeRange(anIndex, 1))
    }
    
    ///
    /// - parameter substring:
    /// - Returns:
    func range(of substring: String) -> NSRange {
        return ns.range(of: substring)
    }
    
    ///
    /// - parameter substring:
    /// - Returns:
    func index(of substring: String) -> Int {
        return range(of: substring).location
    }
    
    ///
    /// - parameter options:
    /// - Returns:
    func format(using options: StringFormattingOption = []) -> String {
        return String(with: self, options: options)
    }
    
    /// Returns a new string made by appending to the receiver a given string.
    ///
    /// - Parameters:
    ///     - str: The path component to append to the receiver.
    /// - Returns: A new string made by appending aString to the receiver,
    /// preceded if necessary by a path separator.
    func appendingPathComponent(_ str: String) -> String {
        return ns.appendingPathComponent(str)
    }
    
    /// Returns a new string made by appending to the receiver an extension
    /// separator followed by a given extension.
    ///
    /// - Parameters:
    ///     - ext: The extension to append to the receiver.
    /// - Returns: A new string made by appending to the receiver an extension
    /// separator followed by `ext`.
    func appendingPathExtension(_ ext: String) -> String? {
        return ns.appendingPathExtension(ext)
    }
    
    /// Returns a new string in which all occurrences of a target string in a
    /// specified range of the receiver are replaced by another given string.
    ///
    /// - Parameters:
    ///     - target: to replace.
    ///     - replacement: to replace `target` with.
    ///     - options: to use when comparing `target` with the receiver.
    ///     - range: in the receiver in which to search for `target`.
    /// - Returns: A new string in which all occurrences of `target`, matched
    /// using `options`, in `searchRange` of the receiver are replaced by
    /// `replacement`.
    func replacingOccurrences(of target: String, with replacement: String, options: NSString.CompareOptions, range: NSRange) -> String {
        return ns.replacingOccurrences(of: target, with: replacement, options: options, range: range)
    }
    
    ///
    ///
    /// - Parameters:
    ///     - string:
    ///     - options:
    ///     - range:
    /// - Returns:
    func matches(in string: String, options: NSRegularExpression.Options, range: NSRange? = nil) -> [NSTextCheckingResult] {
        return matches(in: string, options: (options, []), range: range)
    }
    
    ///
    ///
    /// - Parameters:
    ///     - string:
    ///     - options:
    ///     - range:
    /// - Returns:
    func matches(in string: String, options: NSRegularExpression.MatchingOptions, range: NSRange? = nil) -> [NSTextCheckingResult] {
        return matches(in: string, options: ([], options), range: range)
    }
    
    ///
    ///
    /// - Parameters:
    ///     - string:
    ///     - options:
    ///     - range:
    /// - Returns:
    func matches(in string: String, options: (NSRegularExpression.Options, NSRegularExpression.MatchingOptions) = ([],[]), range: NSRange? = nil) -> [NSTextCheckingResult] {
        do {
            return (try NSRegularExpression(pattern: self, options: options.0))
                .matches(in: string,
                         options: options.1,
                         range: range ?? string.range)
        } catch {
            print(error.localizedDescription)
        }
        return []
    }
    
    ///
    ///
    /// - Parameters:
    ///     - string:
    ///     - options:
    ///     - range:
    ///     - block:
    /// - Returns:
    func enumerateMatches(in string: String, options: NSRegularExpression.Options, range: NSRange? = nil, using block: (NSTextCheckingResult?, NSRegularExpression.MatchingFlags, UnsafeMutablePointer<ObjCBool>) -> Void) {
        enumerateMatches(in: string, options: (options, []), using: block)
    }
    
    ///
    ///
    /// - Parameters:
    ///     - string:
    ///     - options:
    ///     - range:
    ///     - block:
    /// - Returns:
    func enumerateMatches(in string: String, options: NSRegularExpression.MatchingOptions, range: NSRange? = nil, using block: (NSTextCheckingResult?, NSRegularExpression.MatchingFlags, UnsafeMutablePointer<ObjCBool>) -> Void) {
        enumerateMatches(in: string, options: ([], options), using: block)
    }
    
    ///
    ///
    /// - Parameters:
    ///     - string:
    ///     - options:
    ///     - range:
    ///     - block:
    /// - Returns:
    func enumerateMatches(in string: String, options: (NSRegularExpression.Options, NSRegularExpression.MatchingOptions) = ([],[]), range: NSRange? = nil, using block: (NSTextCheckingResult?, NSRegularExpression.MatchingFlags, UnsafeMutablePointer<ObjCBool>) -> Void) {
        do {
            (try NSRegularExpression(pattern: self, options: options.0))
                .enumerateMatches(in: string,
                                  options: options.1,
                                  range: range ?? string.range,
                                  using: block)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    ///
    ///
    /// - Parameters:
    ///     - string:
    ///     - options:
    ///     - range:
    /// - Returns:
    func doesMatch(_ string: String, options: NSRegularExpression.Options, range: NSRange? = nil) -> Bool {
        return doesMatch(string, options: (options, []), range: range)
    }
    
    ///
    ///
    /// - Parameters:
    ///     - string:
    ///     - options:
    ///     - range:
    /// - Returns:
    func doesMatch(_ string: String, options: NSRegularExpression.MatchingOptions, range: NSRange? = nil) -> Bool {
        return doesMatch(string, options: ([], options), range: range)
    }
    
    ///
    ///
    /// - Parameters:
    ///     - string:
    ///     - options:
    ///     - range:
    /// - Returns:
    func doesMatch(_ string: String, options: (NSRegularExpression.Options, NSRegularExpression.MatchingOptions) = ([],[]), range: NSRange? = nil) -> Bool {
        return firstMatch(in: string, options: options, range: range) != nil
    }
    
    ///
    ///
    /// - Parameters:
    ///     - string:
    ///     - options:
    ///     - range:
    /// - Returns:
    func firstMatch(in string: String, options: NSRegularExpression.Options, range: NSRange? = nil) -> NSTextCheckingResult? {
        return firstMatch(in: string, options: (options, []), range: range)
    }
    
    ///
    ///
    /// - Parameters:
    ///     - string:
    ///     - options:
    ///     - range:
    /// - Returns:
    func firstMatch(in string: String, options: NSRegularExpression.MatchingOptions, range: NSRange? = nil) -> NSTextCheckingResult? {
        return firstMatch(in: string, options: ([], options), range: range)
    }
    
    ///
    ///
    /// - Parameters:
    ///     - string:
    ///     - options:
    ///     - range:
    /// - Returns:
    func firstMatch(in string: String, options: (NSRegularExpression.Options, NSRegularExpression.MatchingOptions) = ([],[]), range: NSRange? = nil) -> NSTextCheckingResult? {
        do {
            return (try NSRegularExpression(pattern: self, options: options.0))
                .firstMatch(in: string,
                            options: options.1,
                            range: range ?? string.range)
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    ///
    ///
    ///
    func split(by pattern: String) -> [String] {
        guard let re = try? NSRegularExpression(pattern: pattern, options: [])
            else { return [] }
        let nsString = self as NSString // needed for range compatibility
        let stop = "<SomeStringThatYouDoNotExpectToOccurInSelf>"
        let modifiedString = re.stringByReplacingMatches(
            in: self,
            options: [],
            range: NSRange(location: 0, length: nsString.length),
            withTemplate: stop)
        return modifiedString.components(separatedBy: stop)
    }
    
    ///
    ///
    /// - Parameters:
    ///     - attributes:
    /// - Returns:
    func size(withAttributes attributes: [NSAttributedStringKey: Any]) -> CGSize {
        return ns.size(withAttributes: attributes)
    }
    
    ///
    ///
    /// - Parameters:
    ///     - attributes:
    /// - Returns:
    func width(withAttributes attributes: [NSAttributedStringKey: Any]) -> CGFloat {
        return size(withAttributes: attributes).width
    }
    
    ///
    ///
    /// - Parameters:
    ///     - attributes:
    /// - Returns:
    func height(withAttributes attributes: [NSAttributedStringKey: Any]) -> CGFloat {
        return size(withAttributes: attributes).height
    }
    
    ///
    ///
    /// - Parameters:
    ///     - size:
    ///     - options:
    ///     - attributes:
    ///     - context:
    /// - Returns:
    func boundingRect(with size: CGSize, options: NSStringDrawingOptions = [],  attributes: [NSAttributedStringKey: Any]? = nil, context: NSStringDrawingContext? = nil) -> CGRect {
        return ns.boundingRect(with: size,
                               options: options,
                               attributes: attributes,
                               context: context)
    }
    
    ///
    ///
    /// - Parameters:
    ///     - size:
    ///     - options:
    ///     - attributes:
    ///     - context:
    /// - Returns:
    func boundingSize(with size: CGSize, options: NSStringDrawingOptions = [],  attributes: [NSAttributedStringKey: Any]? = nil, context: NSStringDrawingContext? = nil) -> CGSize {
        return boundingRect(with: size,
                            options: options,
                            attributes: attributes,
                            context: context).size
    }
    
    ///
    ///
    /// - Parameters:
    ///     - height:
    ///     - options:
    ///     - attributes:
    ///     - context:
    /// - Returns:
    func boundingWidth(forHeight height: CGFloat, options: NSStringDrawingOptions = [],  attributes: [NSAttributedStringKey: Any]? = nil, context: NSStringDrawingContext? = nil) -> CGFloat {
        return boundingRect(with: CGSize(width: .max, height: height),
                            options: options,
                            attributes: attributes,
                            context: context).width
    }
    
    ///
    ///
    /// - Parameters:
    ///     - width:
    ///     - options:
    ///     - attributes:
    ///     - context:
    /// - Returns:
    func boundingHeight(forWidth width: CGFloat, options: NSStringDrawingOptions = [],  attributes: [NSAttributedStringKey: Any]? = nil, context: NSStringDrawingContext? = nil) -> CGFloat {
        return boundingRect(with: CGSize(width: width, height: .max),
                            options: options,
                            attributes: attributes,
                            context: context).height
    }
    
    func row(forOffset offset: Int) -> Int {
        var length = 0
        var n = 0
        for line in components(separatedBy: .newlines) {
            if offset >= length && offset < length + line.length + 1 {
                return n
            }
            n += 1
            length += line.length + 1
        }
        return -1
    }
    
    func column(forOffset offset: Int) -> Int {
        return offset - ns.paragraphRange(for: NSMakeRange(offset, 0)).location
    }
    
}

// MARK: - String Path Concatenation
extension String {
    
    static func +/ (lhs: String, rhs: String) -> String {
        return lhs.appendingPathComponent(rhs)
    }
    
    static func +/ (lhs: String?, rhs: String) -> String? {
        guard let lhs = lhs else { return nil }
        return lhs.appendingPathComponent(rhs)
    }
    
    static func +/ (lhs: String, rhs: String?) -> String? {
        guard let rhs = rhs else { return nil }
        return lhs.appendingPathComponent(rhs)
    }
    
}

extension String {
    
    ///
    init(with arg: CVarArg, options: StringFormattingOption = []) {
        var text = String(format: "%@", arg)
        switch options {
            
        case _ where options.contains(.stripOuterBraces):
            break
            
        default:
            break
            
        }
        if options.contains(.escaped) {
            text = text.ns.replacingOccurrences(of: "\\r", with: "\\\\r", options: .regularExpression, range: text.range)
            text = text.ns.replacingOccurrences(of: "\\n", with: "\\\\n", options: .regularExpression, range: text.range)
            text = text.ns.replacingOccurrences(of: "\\t", with: "\\\\t", options: .regularExpression, range: text.range)
            text = text.ns.replacingOccurrences(of: "\\s", with: "\\\\s", options: .regularExpression, range: text.range)
        }
        self = text
    }
    
}


// MARK: - String Font Method Extensions
extension String {
    
    /// Attempts to return the font specified by name of the appropriate point
    /// size for this string to fit within a particular container size and
    /// constrained to a lower and upper bound point size.
    ///
    /// - Parameters:
    ///     - name: of the font.
    ///     - containerSize: that this string should fit inside.
    ///     - lowerBound: minimum allowable point size of this font.
    ///     - upperBound: maximum allowable point size of this font.
    /// - Returns: the font specified by name of the appropriate point
    /// size for this string to fit within a particular container size and
    /// constrained to a lower and upper bound point size; `nil` if no such
    /// font exists.
    func font(named name: String,
              toFit containerSize: CGSize,
              noSmallerThan lowerBound: CGFloat = 1.0,
              noLargerThan upperBound: CGFloat = 256.0) -> UIFont? {
        let lowerBound = lowerBound > upperBound ? upperBound : lowerBound
        let mid = lowerBound + (upperBound - lowerBound) / 2
        guard let tempFont = UIFont(name: name, size: mid) else { return nil }
        let difference = containerSize.height -
            self.size(withAttributes: [.font : tempFont]).height
        if mid == lowerBound || mid == upperBound {
            return UIFont(name: name, size: difference < 0 ? mid - 1 : mid)
        }
        return difference < 0 ? font(named: name,
                                     toFit: containerSize,
                                     noSmallerThan: mid,
                                     noLargerThan: mid - 1) :
            (difference > 0 ? font(named: name,
                                   toFit: containerSize,
                                   noSmallerThan: mid,
                                   noLargerThan: mid - 1) :
                UIFont(name: name, size: mid))
    }
    
    /// Returns the system font of the appropriate point size for this string
    /// to fit within a particular container size and constrained to a lower
    /// and upper bound point size.
    ///
    /// - Parameters:
    ///     - containerSize: that this string should fit inside.
    ///     - lowerBound: minimum allowable point size of this font.
    ///     - upperBound: maximum allowable point size of this font.
    /// - Returns: the system font of the appropriate point size for this string
    /// to fit within a particular container size and constrained to a lower
    /// and upper bound point size.
    func systemFont(toFit containerSize: CGSize,
                    noSmallerThan lowerBound: CGFloat = 1.0,
                    noLargerThan upperBound: CGFloat = 256.0) -> UIFont {
        let lowerBound = lowerBound > upperBound ? upperBound : lowerBound
        let mid = lowerBound + (upperBound - lowerBound) / 2
        let tempFont = UIFont.systemFont(ofSize: mid)
        let difference = containerSize.height -
            self.size(withAttributes: [.font : tempFont]).height
        if mid == lowerBound || mid == upperBound {
            return UIFont.systemFont(ofSize: difference < 0 ? mid - 1 : mid)
        }
        return difference < 0 ? systemFont(toFit: containerSize,
                                           noSmallerThan: mid,
                                           noLargerThan: mid - 1) :
            (difference > 0 ? systemFont(toFit: containerSize,
                                         noSmallerThan: mid,
                                         noLargerThan: mid - 1) :
                UIFont.systemFont(ofSize: mid))
    }
    
}

// MARK: - String UIImage Extensions
extension String {
    
    /// Generates a `UIImage` instance from this string using a specified
    /// attributes and size.
    ///
    /// - Parameters:
    ///     - attributes: to draw this string with. Default is `nil`.
    ///     - size: of the image to return.
    /// - Returns: a `UIImage` instance from this string using a specified
    /// attributes and size, or `nil` if the operation fails.
    func image(withAttributes attributes: [NSAttributedStringKey: Any]? = nil, size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContext(size)
        let rect = CGRect(origin: .zero, size: size)
        (self as NSString).draw(in: rect, withAttributes: attributes)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        return image
    }
    
}

// MARK: - String Static Extension
extension String {
    
    static func * (lhs: String, rhs: UInt) -> String {
        var string = ""
        for _ in 0 ..< rhs { string += lhs }
        return string
    }
    
}

// MARK: - UIBarButtonItem Extensions
extension UIBarButtonItem {
    
    /// Returns a new bar button system item instance with a `flexibleSpace`
    /// style.
    class var flexibleSpace: UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    }
    
    /// Returns a new bar button system item instance with a `fixedSpace`
    /// style.
    class var fixedSpace: UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
    }
    
}

// MARK: - UIColor Constructor Extensions
extension UIColor {
    
    var rgbaValue: UInt? {
        var fRed: CGFloat = 0
        var fGreen: CGFloat = 0
        var fBlue: CGFloat = 0
        var fAlpha: CGFloat = 0
        if getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
            let iRed = UInt(fRed * 255.0)
            let iGreen = UInt(fGreen * 255.0)
            let iBlue = UInt(fBlue * 255.0)
            let iAlpha = UInt(fAlpha * 255.0)
            let rgba = (iAlpha << 24) + (iRed << 16) + (iGreen << 8) + iBlue
            return rgba
        }
        return nil
    }
    
    var rgbaValues: (UInt, CGFloat)? {
        var fRed: CGFloat = 0
        var fGreen: CGFloat = 0
        var fBlue: CGFloat = 0
        var fAlpha: CGFloat = 0
        if getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
            let iRed = UInt(fRed * 255.0)
            let iGreen = UInt(fGreen * 255.0)
            let iBlue = UInt(fBlue * 255.0)
            let iAlpha = UInt(fAlpha * 255.0)
            let rgb = (iRed << 16) + (iGreen << 8) + iBlue
            return (rgb, CGFloat(iAlpha))
        }
        return nil
    }
    
    /// Creates a new `UIColor` instance from a specified unsigned integer
    /// and alpha float.
    ///
    /// - Parameters:
    ///   - hex: that represents the RGB saturations of this color.
    ///   - alpha: of this color.
    convenience init(_ hex: UInt, alpha: CGFloat? = nil) {
        self.init(red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(hex & 0x0000FF) / 255.0,
                  alpha: alpha ?? (hex > 0xFFFFFF ? (CGFloat((hex & 0xFF000000) >> 24) / 255.0) : 1.0))
    }
    
}

// MARK: - UIColor Operator Extensions
extension UIColor {
    
    /// Creates a new `UIColor` instance from a specified color and with
    /// a specified alpha component.
    /// Shorthand for `color.widthAlphaComponent(alpha)`.
    ///
    /// - Parameters:
    ///   - color: to generate a new color from.
    ///   - alpha: component to use for the new color.
    /// - Returns: a new `UIColor` instance of `color` with an alpha component
    /// of `alpha`.
    static func * (color: UIColor, alpha: CGFloat) -> UIColor {
        return color.withAlphaComponent(alpha)
    }
    
}

/// Creates a new `UIColor` instance from a specified color and with
/// a specified alpha component.
/// Shorthand for `color.widthAlphaComponent(alpha)`.
///
/// - Parameters:
///   - color: to generate a new color from.
///   - alpha: component to use for the new color.
/// - Returns: a new `UIColor` instance of `color` with an alpha component
/// of `alpha`.
func * (color: UIColor?, alpha: CGFloat) -> UIColor? {
    return color?.withAlphaComponent(alpha)
}

// MARK: - UIDevice Platform Extension
extension UIDevice {
    
    ///
    struct Platform {
        
        ///
        enum Model: String {
            
            case unspecified
            
            case iPhone5
            case iPhone5C
            case iPhone5S
            case iPhone6
            case iPhone6S
            case iPhone6Plus
            case iPhone7
            case iPhone7Plus
            case iPhone8
            case iPhone8Plus
            case iPhoneX
            case iPhoneXR
            case iPhoneXS
            case iPhoneXSMax
            
        }
        
        ///
        enum ModelSeries: String {
            
            case unspecified
            
            case iPhone5
            case iPhone6
            case iPhone7
            case iPhone8
            case iPhoneX
            case iPhoneXR
            case iPhoneXS
            
        }
        
        ///
        typealias This = Platform
        
        ///
        static let phoneDimensionModelMap: [CGFloat: [Model]] = [
            1136: [.iPhone5, .iPhone5C, .iPhone5S],
            1134: [.iPhone6, .iPhone6S, .iPhone7, .iPhone8],
            1792: [.iPhoneXR],
            1920: [.iPhone6Plus, .iPhone7Plus, .iPhone8Plus],
            2208: [.iPhone6Plus, .iPhone7Plus, .iPhone8Plus],
            2436: [.iPhoneX, .iPhoneXS],
            2688: [.iPhoneXSMax]
        ]
        
        ///
        static let padDimensionModelMap: [CGFloat: [Model]] = [
            :
        ]
        
        ///
        static let phoneNameMap: [String: ModelSeries] = [
            "iPhone10": .iPhoneX,
            "iPhone11": .iPhoneXS,
            ]
        
        ///
        static let padNameMap: [String: ModelSeries] = [
            :
        ]
        
        ///
        let idiom: UIUserInterfaceIdiom
        
        ///
        let model: Model
        
        ///
        var isPhone: Bool { return idiom == .phone }
        
        ///
        var isPad: Bool { return idiom == .pad }
        
        ///
        var isIphoneX: Bool {
            return [.iPhoneX, .iPhoneXR, .iPhoneXS, .iPhoneXSMax].contains(model)
        }
        
        ///
        init(idiom: UIUserInterfaceIdiom, model: Model) {
            self.idiom = idiom
            self.model = model
        }
        
        ///
        static var systemPlatform: Platform = {
            
            var modelVersion: String
            if UIDevice.isSimulator {
                modelVersion = ProcessInfo.processInfo.environment["SIMULATOR_MODEL_IDENTIFIER"] ?? ""
            } else {
                var size = 0
                sysctlbyname("hw.machine", nil, &size, nil, 0)
                var machine = [CChar](repeating: 0, count: size)
                sysctlbyname("hw.machine", &machine, &size, nil, 0)
                modelVersion = String(cString: machine)
            }
            
            let idiom = UIDevice().userInterfaceIdiom
            var model: Model?
            
            switch idiom {
                
            case .phone:
                model = This.phoneDimensionModelMap[UIScreen.main.nativeBounds.size.height]?.first
                break
                
            case .pad:
                break
                
            default:
                break
                
            }
            
            return Platform(idiom: idiom, model: model ?? .unspecified)
            
        }()
        
    }
    
}

// MARK: - UIDevice Class Property Extensions
extension UIDevice {
    
    /// `true` if this application is running on a simulator. `false`,
    /// otherwise.
    class var isSimulator: Bool {
        return TARGET_OS_SIMULATOR != 0
    }
    
    /// Shorthand for `Platform.systemPlatform`.
    class var platform: Platform {
        return Platform.systemPlatform
    }
    
    ///
    class var isPhone: Bool { return platform.isPhone }
    
    ///
    class var isPad: Bool { return platform.isPad }
    
    ///
    class var isIphoneX: Bool { return platform.isIphoneX }
    
}

// MARK: - UIFont Constructor Extensions
extension UIFont {
    
    /// Returns a system font instance with point size set to
    /// `UIFont.systemFontSize`.
    static var `default`: UIFont {
        return systemFont(ofSize: systemFontSize)
    }
    
}

// MARK: - UIImage Property Extensions
extension UIImage {
    
    /// Width of this image.
    var width: CGFloat {
        return size.width
    }
    
    /// Height of this image.
    var height: CGFloat {
        return size.height
    }
    
}

// MARK: - UIImage Method Extensions
extension UIImage {
    
    ///
    struct CGAttribute: BaseRawRepresentable {
        
        typealias This = CGAttribute
        typealias RawValue = String
        
        let rawValue: String
        
        static let tintColor = This("tintColor")
        static let alpha = This("alpha")
        static let shadow = This("shadow")
        static let cropSize = This("cropSize")
        
        init(rawValue: RawValue) {
            self.rawValue = rawValue
        }
        
    }
    
    /// Returns a version of this image that is redrawn with specified
    /// attributes.
    ///
    /// - Parameters:
    ///     - attributes: to redraw this image with.
    /// - Returns: A version of this image that is redrawn with the specified
    /// `attributes`, or `nil` if this operation fails.
    func with(attributes: [CGAttribute: Any]) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        guard
            let cgImage = cgImage,
            let context = UIGraphicsGetCurrentContext()
            else { return nil }
        let rect = CGRect(origin: .zero, size: size)
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        if let shadow = attributes[.shadow] as? NSShadow {
            context.setShadow(offset: shadow.shadowOffset,
                              blur: shadow.shadowBlurRadius,
                              color: (shadow.color ?? UIColor.black * 0.2).cgColor)
        }
        context.draw(cgImage, in: rect)
        context.clip(to: rect, mask: cgImage)
        if let tintColor = attributes[.tintColor] as? UIColor {
            context.setFillColor(tintColor.cgColor)
            context.setBlendMode(.screen)
            context.fill(rect)
        }
        if let alpha = attributes[.alpha] as? CGFloat, alpha < 1.0 {
            context.setFillColor(UIColor.white.cgColor)
            context.setBlendMode(.normal)
            context.setAlpha(1.0 - alpha)
            context.fill(rect)
        }
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let cropSize = attributes[.cropSize] as? CGSize {
            return newImage?.scalingAndCropping(to: cropSize)
        }
        return newImage
    }
    
    /// Returns an image that is scaled and cropped to a target size.
    ///
    /// - Parameters:
    ///     - targetSize: Size to scale and/or crop this image to.
    /// - Returns: A copy of this image that is scaled and cropped to a
    /// target size.
    func scalingAndCropping(to targetSize: CGSize) -> UIImage? {
        
        var scaleFactor: CGFloat = 0.0
        var scaledSize = targetSize
        var thumbnailOrigin: CGPoint = .zero
        
        if (size != targetSize) {
            
            let widthFactor = targetSize.width / width
            let heightFactor = targetSize.height / height
            
            scaleFactor = max(widthFactor, heightFactor)
            
            scaledSize.width = width * scaleFactor
            scaledSize.height = height * scaleFactor
            
            if (widthFactor > heightFactor) {
                thumbnailOrigin.y = (targetSize.height - scaledSize.height) * 0.5
            } else if (widthFactor < heightFactor) {
                thumbnailOrigin.x = (targetSize.width - scaledSize.width) * 0.5
            }
            
        }
        
        UIGraphicsBeginImageContext(targetSize)
        
        let rect = CGRect(origin: thumbnailOrigin, size: scaledSize)
        draw(in: rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
        
    }
    
}

// MARK: - UIView Property Extensions
extension UIView {
    
    var origin: CGPoint {
        get { return frame.origin }
        set { frame.origin = newValue }
    }
    
    var size: CGSize {
        get { return frame.size }
        set { frame.size = newValue }
    }
    
    /// x value of the origin coordinate of this view.
    var x: CGFloat {
        get { return origin.x }
        set { origin.x = newValue }
    }
    
    /// y value of the origin coordinate of this view.
    var y: CGFloat {
        get { return origin.y }
        set { origin.y = newValue }
    }
    
    /// Width of this view.
    var width: CGFloat {
        get { return size.width }
        set { size.width = newValue }
    }
    
    /// Height of this view.
    var height: CGFloat {
        get { return size.height }
        set { size.height = newValue }
    }
    
    /// Offset width of this view. Returns `x + width`.
    var offsetWidth: CGFloat {
        return x + width
    }
    
    /// Offset height of this view. Returns `y + height`.
    var offsetHeight: CGFloat {
        return y + height
    }
    
}

extension UIView {
    
    func add(border edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        layoutIfNeeded()
        layer.add(border: edge, color: color, thickness: thickness)
    }
    
}

extension CALayer {
    
    func add(border edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        
        let border = CALayer()
        
        switch edge {
        case .top:
            border.frame = CGRect(x: 0, y: 0, width: frame.width, height: thickness)
        case .bottom:
            border.frame = CGRect(x: 0, y: frame.height - thickness, width: frame.width, height: thickness)
        case .left:
            border.frame = CGRect(x: 0, y: 0, width: thickness, height: frame.height)
        case .right:
            border.frame = CGRect(x: frame.width - thickness, y: 0, width: thickness, height: frame.height)
        default:
            break
        }
        
        border.backgroundColor = color.cgColor;
        
        addSublayer(border)
    }
    
}

// MARK: - UIViewController Property Extensions
extension UIViewController {
    
    /// Embeds this view controller as the root view controller of a new
    /// `UINavigationController` instance, and returns that instance.
    var asNavigationController: UINavigationController {
        return UINavigationController(rootViewController: self)
    }
    
}

// MARK: - URL Property Extensions
extension URL {
    
    ///
    var pathComponentsResolvingSymlinksInPath: [String] {
        return resolvingSymlinksInPath().pathComponents
    }
    
    @available(OSX 10.11, iOS 9.0, *)
    func relativeTo(baseURL: URL) -> URL {
        return URL(fileURLWithPath: resolvingSymlinksInPath().path, relativeTo: baseURL)
    }
    
}

// MARK: - URL Path Concatenation
extension URL {
    
    static func +/ (lhs: URL, rhs: String) -> URL {
        return lhs.appendingPathComponent(rhs)
    }
    
    static func +/ (lhs: URL, rhs: String?) -> URL? {
        guard let rhs = rhs else { return nil }
        return lhs.appendingPathComponent(rhs)
    }
    
}

func +/ (lhs: URL?, rhs: String) -> URL? {
    guard let lhs = lhs else { return nil }
    return lhs.appendingPathComponent(rhs)
}

// MARK: - UserDefaults Subscript Extensions
extension UserDefaults {
    
    /// Shorthand for `value(forKey:)` and `set(_, forKey:)`.
    ///
    /// - Parameters:
    ///     - value: to set in user defaults.
    ///     - key: key of the user default value to set/retrieve.
    subscript <UserDefaultsValueType>(key: String) -> UserDefaultsValueType? {
        get { return value(forKey: key) as? UserDefaultsValueType }
        set { set(newValue, forKey: key) }
    }
    
    /// Shorthand for `value(forKey:)` and `set(_, forKey:)`.
    ///
    /// - Parameters:
    ///     - value: to set in user defaults.
    ///     - key: key of the user default value to set/retrieve.
    subscript <UserDefaultsValueType, RawRepresentableType: RawRepresentable>(key: RawRepresentableType) -> UserDefaultsValueType? where RawRepresentableType.RawValue == String {
        get { return value(forKey: key.rawValue) as? UserDefaultsValueType }
        set { set(newValue, forKey: key.rawValue) }
    }
    
}

// MARK: - RawRepresentable Static Initializer Extensions

extension RawRepresentable {
    
    /// Returns a new instance of this raw representable with an initial
    /// raw value, or `nil` if the specified raw value is `nil`.
    ///
    /// - Parameters:
    ///     - rawValue: to set for the new instance.
    /// - Returns: a new instance of this raw representable with an initial
    /// raw value, or `nil` if `rawValue` is `nil`.
    static func from(_ rawValue: RawValue?) -> Self? {
        guard let rawValue = rawValue else { return nil }
        return Self.init(rawValue: rawValue)
    }
    
    /// Returns a collection of raw representable instances from a collection
    /// of raw values, or and empty collection if the specified collection of
    /// raw values is `nil`.
    ///
    /// - Parameters:
    ///     - rawValues: to generate new instances from.
    /// - Returns: a collection of raw representable instances from a collection
    /// of raw values, or and empty collection if `rawValues` is `nil`.
    static func from(_ rawValues: [RawValue]?) -> [Self] {
        guard let rawValues = rawValues else { return [] }
        var values = [Self]()
        rawValues.forEach {
            guard let newValue = Self.init(rawValue: $0) else { return }
            values.append(newValue)
        }
        return values
    }
    
}

// MARK: - RawRepresentable Dictionary Extensions

extension Dictionary {
    
    subscript <RawRepresentableType: RawRepresentable>(key: RawRepresentableType) -> Value?
        where RawRepresentableType.RawValue == Key {
        get { return self[key.rawValue] }
        set { self[key.rawValue] = newValue }
    }
    
}

// MARK: - RawRepresentable Equatable Operator Extensions

func == <EquatableType: Equatable, RawRepresentableType: RawRepresentable>
    (lhs: EquatableType, rhs: RawRepresentableType) -> Bool
    where EquatableType == RawRepresentableType.RawValue {
        return lhs == rhs.rawValue
}

func != <EquatableType: Equatable, RawRepresentableType: RawRepresentable>
    (lhs: EquatableType, rhs: RawRepresentableType) -> Bool
    where EquatableType == RawRepresentableType.RawValue {
        return lhs != rhs.rawValue
}

func == <EquatableType: Equatable, RawRepresentableType: RawRepresentable>
    (lhs: RawRepresentableType, rhs: EquatableType) -> Bool
    where EquatableType == RawRepresentableType.RawValue {
        return lhs.rawValue == rhs
}

func != <EquatableType: Equatable, RawRepresentableType: RawRepresentable>
    (lhs: RawRepresentableType, rhs: EquatableType) -> Bool
    where EquatableType == RawRepresentableType.RawValue {
        return lhs.rawValue != rhs
}

func == <EquatableType: Equatable, RawRepresentableType: RawRepresentable>
    (lhs: EquatableType?, rhs: RawRepresentableType) -> Bool
    where EquatableType == RawRepresentableType.RawValue {
        return lhs == rhs.rawValue
}

func != <EquatableType: Equatable, RawRepresentableType: RawRepresentable>
    (lhs: EquatableType?, rhs: RawRepresentableType) -> Bool
    where EquatableType == RawRepresentableType.RawValue {
        return lhs != rhs.rawValue
}

func == <EquatableType: Equatable, RawRepresentableType: RawRepresentable>
    (lhs: RawRepresentableType?, rhs: EquatableType) -> Bool
    where EquatableType == RawRepresentableType.RawValue {
        return lhs?.rawValue == rhs
}

func != <EquatableType: Equatable, RawRepresentableType: RawRepresentable>
    (lhs: RawRepresentableType?, rhs: EquatableType) -> Bool
    where EquatableType == RawRepresentableType.RawValue {
        return lhs?.rawValue != rhs
}

func == <EquatableType: Equatable, RawRepresentableType: RawRepresentable>
    (lhs: EquatableType, rhs: RawRepresentableType?) -> Bool
    where EquatableType == RawRepresentableType.RawValue {
        return lhs == rhs?.rawValue
}

func != <EquatableType: Equatable, RawRepresentableType: RawRepresentable>
    (lhs: EquatableType, rhs: RawRepresentableType?) -> Bool
    where EquatableType == RawRepresentableType.RawValue {
        return lhs != rhs?.rawValue
}

func == <EquatableType: Equatable, RawRepresentableType: RawRepresentable>
    (lhs: RawRepresentableType, rhs: EquatableType?) -> Bool
    where EquatableType == RawRepresentableType.RawValue {
        return lhs.rawValue == rhs
}

func != <EquatableType: Equatable, RawRepresentableType: RawRepresentable>
    (lhs: RawRepresentableType, rhs: EquatableType?) -> Bool
    where EquatableType == RawRepresentableType.RawValue {
        return lhs.rawValue != rhs
}

// MARK: - BaseRawRepresentable Protocol

/// Specifications for a raw representable that is hashable and has non-failable
/// constructors.
protocol BaseRawRepresentable: Hashable, RawRepresentable where RawValue: Hashable {
    
    /// Constructs a new instance of this raw representable with an initial
    /// raw value.
    ///
    /// - Parameters:
    ///     - rawValue: to set for the new instance.
    init(_ rawValue: RawValue)
    
    /// Constructs a new instance of this raw representable with an initial
    /// raw value.
    ///
    /// - Parameters:
    ///     - rawValue: to set for the new instance.
    init(rawValue: RawValue)
    
}

extension BaseRawRepresentable {
    
    public var hashValue: Int { return rawValue.hashValue }
    
    init(_ rawValue: RawValue) {
        self.init(rawValue: rawValue)
    }
    
    func equals(_ values: Self...) -> Bool {
        return values.contains(self)
    }
    
}

// MARK: - DefaultBaseRawRepresentable Protocol

/// Specifications for a base raw representable that has a default raw value
/// for instances constructed with a `nil` raw value.
protocol DefaultBaseRawRepresentable: BaseRawRepresentable {
    
    /// Default raw value to assign an instance constructed with a `nil`
    /// raw value.
    static var defaultRawValue: RawValue { get }
    
    /// Default raw representable value of this raw representable type.
    static var `default`: Self { get }
    
    /// Constructs a new option set instance from an optional raw value.
    /// This constructor defaults the raw value of the instance to
    /// `This.defaultRawValue` if the specified `rawValue` is `nil`.
    init(_ rawValue: RawValue?)
    
    /// Constructs a new option set instance from an optional raw value.
    /// This constructor defaults the raw value of the instance to
    /// `This.defaultRawValue` if the specified `rawValue` is `nil`.
    init(rawValue: RawValue?)
    
}

extension DefaultBaseRawRepresentable {
    
    static var `default`: Self { return Self(Self.defaultRawValue) }
    
    init(_ rawValue: RawValue?) {
        self.init(rawValue: rawValue ?? Self.defaultRawValue)
    }
    
    init(rawValue: RawValue?) {
        self.init(rawValue: rawValue ?? Self.defaultRawValue)
    }
    
}

// MARK: - BaseOptionSet Protocol

/// Specifications for an option set with failable constructors.
protocol BaseOptionSet: BaseRawRepresentable, OptionSet {
    
}

extension BaseOptionSet {
    
    init?(_ rawValue: RawValue?) {
        guard let rawValue = rawValue else { return nil }
        self.init(rawValue: rawValue)
    }
    
    init?(rawValue: RawValue?) {
        guard let rawValue = rawValue else { return nil }
        self.init(rawValue: rawValue)
    }
    
}

// MARK: - Serializable Protocol

/// Specifications for an object that can be converted into a dictionary.
protocol Serializable {}

extension Serializable {
    
    /// Converts this object into a dictionary.
    ///
    /// - Returns: This object as a dictionary.
    func toDict() -> [String: Any] {
        var dict = [String: Any]()
        Mirror(reflecting: self).children.forEach {
            if let key = $0.label {
                dict[key] = $0.value
            }
        }
        return dict
    }
    
}

