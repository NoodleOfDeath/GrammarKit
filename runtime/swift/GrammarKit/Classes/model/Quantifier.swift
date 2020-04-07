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

/// Data structure representing a quantifier.
public struct Quantifier: Codable {

    typealias This = Quantifier

    /// Quantifier for none or more.
    public static let noneOrMore =
        Quantifier(string: "*", optional: true, greedy: true, lazy: false)

    /// Quantifier for none or more lazy.
    public static let noneOrMoreLazy =
        Quantifier(string: "*?", optional: true, greedy: true, lazy: true)

    /// Quantifier for once.
    public static let once =
        Quantifier(string: "", optional: false, greedy: false, lazy: false)

    /// Quantifier for once or more.
    public static let onceOrMore =
        Quantifier(string: "+", optional: false, greedy: true, lazy: false)

    /// Quantifier for once or more lazy.
    public static let onceOrMoreLazy =
        Quantifier(string: "+?", optional: false, greedy: true, lazy: true)

    /// Quantifier for optional.
    public static let optional =
        Quantifier(string: "?", optional: true, greedy: false, lazy: false)

    /// Quantifier for optional lazy.
    public static let optionalLazy =
        Quantifier(string: "??", optional: true, greedy: false, lazy: true)

    /// Regular expression for matching quantifier ranges.
    public static let rangeExpression = "\\{\\s*(\\d)?(?:\\s*(,)\\s*(\\d)?)?\\s*\\}(\\?)?"

    /// All preset quantifier values.
    public static let values: [Quantifier] = [
        .noneOrMore, .noneOrMoreLazy,
        .once, .onceOrMore, .onceOrMoreLazy,
        .optional, .optionalLazy,
    ]

    /// Mapping of preset quantifier string values to their respective
    /// quanitifer instance.
    public static let valueMap: [String: Quantifier] = [
        noneOrMore.string: noneOrMore,
        noneOrMoreLazy.string: noneOrMoreLazy,
        once.string: once,
        onceOrMore.string: onceOrMore,
        onceOrMoreLazy.string: onceOrMoreLazy,
        optional.string: optional,
        optionalLazy.string: optionalLazy,
    ]
    
    /// String of this quantifier.
    public let string: String
    
    /// `true` if this quantifier is optional; `false`, otherwise.
    public let optional: Bool
    
    /// `true` if this quantifier is greedy; `false`, otherwise.
    public let greedy: Bool
    
    /// `true` if this quantifier is lazy; `false`, otherwise.
    public let lazy: Bool
    
    /// Minimum match count of this quantifier. A negative value indicates
    /// that `range` is not set.
    public var min: Int
    
    /// Maximum match count of this quantifier. A negative value indicates
    /// that `range` is not set.
    public var max: Int

    /// Range of this quantifier.
    public var range: ClosedRange<Int> { return min ... max }

    /// `true` if, and only if, `min > -1 && max > -1`.
    public var hasRange: Bool {
        return min > -1 && max > -1
    }
    
    /// Returns `true` if this quantifier can match the number of times
    /// specified by `matchCount`; `false`, otherwise.
    ///
    /// - Parameters:
    ///     - matchCount: number of matches this quantifier must meet.
    /// - Returns: `true` if this quantifier can match the number of times
    /// specified by `matchCount`; `false`, otherwise.
    public func matches(_ matchCount: Int) -> Bool {
        return range.contains(matchCount)
    }
    
    /// Constructs a new quantifier instance with an initial string value,
    /// optional/greedy/lazy flags, and min/max values.
    ///
    /// - Parameters:
    ///     - string: representation of this quantifier.
    ///     - optional: `true` if this quantifier is optional; `false`, otherwise.
    ///     - greedy: `true` if this quantifier is greedy; `false`, otherwise.
    ///     - lazy: `true` if this quantifier is lazy; `false`, otherwise.
    ///     - min: of this quantifier.
    ///     - max: of this quantifier.
    public init(string: String, optional: Bool = false, greedy: Bool = false, lazy: Bool = false, min: Int = -1, max: Int = -1) {
        self.string = string
        self.optional = optional
        self.greedy = greedy
        self.lazy = lazy
        self.min = min
        self.max = max
    }
    
    /// Constructs a new quantifier instance from a string value.
    ///
    /// - Parameters:
    ///     - string: to parse a new quantifier instance from.
    /// - Returns: a new quantifier instance parsed from `string`.
    public init(_ string: String?) {
        guard let string = string else { self = .once; return }
        guard string.index(of: "{") == 0, let match = This.rangeExpression.firstMatch(in: string) else {
            self = This.valueMap[string] ?? .once
            return
        }
        let min = Int(string.substring(with: match.range(at: 1))) ?? -1
        let max = match.range(at: 2).length > 0 ? Int(string.substring(with: match.range(at: 3))) ?? 9 : min
        let lazy = match.range(at: 4).length > 0
        self.init(string: string,
                  optional: min <= 0,
                  greedy: min < (min >= max ? min : max),
                  lazy: lazy,
                  min: min,
                  max: min >= max ? min : max)
    }
    
    /// Returns `true` if, and only if, `quantifers.contains(self)`.
    ///
    /// - Parameters:
    ///     - quantifiers: to test.
    /// - Returns: `true` if, and only if, `quantifers.contains(self)`.
    public func equals(_ quantifiers: Quantifier...) -> Bool {
        return quantifiers.contains(self)
    }
    
}

extension Quantifier: Equatable {
    
    public static func == (lhs: Quantifier, rhs: Quantifier) -> Bool {
        return
            (lhs.string, lhs.optional, lhs.greedy, lhs.lazy, lhs.min, lhs.max) ==
            (rhs.string, rhs.optional, rhs.greedy, rhs.lazy, rhs.min, rhs.max)
    }
    
}

extension Quantifier: CustomStringConvertible {
    
    public var description: String {
        return string
    }
    
}

extension Quantifier: CVarArg {

    public var _cVarArgEncoding: [Int] {
        return description._cVarArgEncoding
    }
    
}
