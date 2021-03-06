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

extension Grammar {
    
    /// Common grammar rule options represented as an enumerated string type.
    public struct MetadataOption: BaseRawRepresentable, Codable {
        
        public typealias This = MetadataOption
        public typealias RawValue = String
        
        public let rawValue: RawValue

        /// Indicates that this rule should not be added to the
        /// rule map of enumerated rules of this container grammar.
        public static let fragment = This("fragment")

        /// Indicates that the lexer/parser should skip notifiying
        /// observers when this rule encounters matches.
        public static let skip = This("skip")

        /// Indicates that this rule should extend off of inherited
        /// implementation(s) as an alternative clause.
        public static let extend = This("extend")
        
        /// Indicates that the rule contains nested scopes.
        public static let nested = This("nested")

        /// Indicates that the rule contains dictionary entries.
        public static let dictionary = This("dictionary")

        public init(rawValue: RawValue) {
            self.rawValue = rawValue
        }
        
        public init?(_ rawValue: RawValue?) {
            guard let rawValue = rawValue else { return nil }
            self.init(rawValue: rawValue)
        }
        
        public init?(rawValue: RawValue?) {
            guard let rawValue = rawValue else { return nil }
            self.init(rawValue: rawValue)
        }
        
        public static func == (lhs: This, rhs: This) -> Bool {
            return lhs.rawValue.lowercased() == rhs.rawValue.lowercased()
        }
        
    }
    
}

extension Grammar.MetadataOption: CustomStringConvertible {

    public var description: String {
        return rawValue
    }

}
