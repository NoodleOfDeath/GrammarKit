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
