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

extension GrammarRule {

    /// Enumerated type representing the types of components that can be found
    /// in the definition of a grammar rule.
    public struct ComponentType: DefaultBaseRawRepresentable, Codable {
        
        static var defaultRawValue: String { return "unknown" }
        
        public typealias This = ComponentType
        public typealias RawValue = String
        
        public let rawValue: RawValue
        
        /// Unknown component type.
        public static let unknown = This("unknown")
        
        /// Atom component type.
        public static let atom = This("atom")
        
        /// Composite component type.
        public static let composite = This("composite")
        
        /// Expression component type.
        public static let expression = This("expression")
        
        /// Literal component type.
        public static let literal = This("literal")
        
        /// Lexer rule component type.
        public static let lexerRuleReference = This("lexerRuleReference")
        
        /// Lexer fragment component type.
        public static let lexerFragmentReference = This("lexerFragmentReference")
        
        /// Parser rule component type.
        public static let parserRuleReference = This("parserRuleReference")
        
        public init(rawValue: RawValue) {
            self.rawValue = rawValue
        }
        
    }

}
