//
//  GrammarKit
//
//  Copyright © 2019 NoodleOfDeath. All rights reserved.
//

import Foundation

///
public struct Quantifier: Codable {
    
    /// String of this quantifier.
    public let string: String
    
    /// Returns `true` if this quantifier is optional.
    public let optional: Bool
    
    /// Returns `true` if this quantifier is greedy.
    public let greedy: Bool
    
    /// Returns `true` if this quantifier is lazy.
    public let lazy: Bool
    
    /// Minimum match count of this quantifier. A negative value indicates
    /// that `range` is not set.
    public var min: Int
    
    /// Maximum match count of this quantifier. A negative value indicates
    /// that `range` is not set.
    public var max: Int
    
    public var hasRange: Bool {
        return min > -1 && max > -1
    }
    
    ///
    /// - parameter matchCount:
    /// - Returns:
    public func meets(_ matchCount: Int) -> Bool {
        return matchCount >= min && matchCount <= max
    }

    /// 
    public static let noneOrMore =
        Quantifier(string: "*", optional: true, greedy: true, lazy: false)
    
    /// 
    public static let noneOrMoreLazy =
        Quantifier(string: "*?", optional: true, greedy: true, lazy: true)
    
    ///
    public static let once =
        Quantifier(string: "", optional: false, greedy: false, lazy: false)
    
    ///
    public static let onceOrMore =
        Quantifier(string: "+", optional: false, greedy: true, lazy: false)
    
    ///
    public static let onceOrMoreLazy =
        Quantifier(string: "+?", optional: false, greedy: true, lazy: true)
    
    ///
    public static let optional =
        Quantifier(string: "?", optional: true, greedy: false, lazy: false)
    
    ///
    public static let optionalLazy =
        Quantifier(string: "??", optional: true, greedy: false, lazy: true)
    
    ///
    public static let values: [Quantifier] = [
        .noneOrMore, .noneOrMoreLazy,
        .once, .onceOrMore, .onceOrMoreLazy,
        .optional, .optionalLazy,
    ]
    
    ///
    public static let valueMap: [String: Quantifier] = [
        noneOrMore.string: noneOrMore,
        noneOrMoreLazy.string: noneOrMoreLazy,
        once.string: once,
        onceOrMore.string: onceOrMore,
        onceOrMoreLazy.string: onceOrMoreLazy,
        optional.string: optional,
        optionalLazy.string: optionalLazy,
    ]
    
    ///
    ///
    /// - Parameters:
    ///     - string:
    ///     - optional:
    ///     - greedy:
    ///     - lazy:
    ///     - range:
    public init(string: String, optional: Bool = false, greedy: Bool = false, lazy: Bool = false, min: Int? = nil, max: Int? = nil) {
        self.string = string
        self.optional = optional
        self.greedy = greedy
        self.lazy = lazy
        self.min = min ?? -1
        self.max = max ?? -1
    }
    
    ///
    ///
    /// - Parameters:
    ///     - string:
    /// - Returns:
    public static func from(_ string: String?) -> Quantifier {
        guard let string = string else { return once }
        if string.index(of: "{") == 0 {
            if let match = "\\{\\s*(\\d)?(?:\\s*(,)\\s*(\\d)?)?\\s*\\}(\\?)?".firstMatch(in: string, range: string.range) {
                let min = Int(string.substring(with: match.range(at: 1))) ?? -1
                let max = match.range(at: 2).length > 0 ? Int(string.substring(with: match.range(at: 3))) ?? 9 : min
                let lazy = match.range(at: 4).length > 0
                return Quantifier(string: string,
                                  optional: min == 0,
                                  greedy: min < max,
                                  lazy: lazy,
                                  min: min,
                                  max: min >= max ? min : max)
            }
        }
        return valueMap[string] ?? once
    }
    
    ///
    public func equals(_ quantifiers: Quantifier...) -> Bool {
        return quantifiers.contains(self)
    }
    
}

extension Quantifier: Equatable {
    
    public static func == (lhs: Quantifier, rhs: Quantifier) -> Bool {
        return (lhs.string, lhs.optional, lhs.greedy, lhs.lazy, lhs.min, lhs.max) == 
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
