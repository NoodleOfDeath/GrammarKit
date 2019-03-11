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

    /// Data structure for determining grammar rule precedence when
    /// sorting grammar rules.
    public struct Precedence: Codable {
        
        ///
        public enum Relation: String, Codable {
            
            ///
            case none = ""
            
            ///
            case lessThan = "<"
            
            ///
            case equalTo = "="
            
            ///
            case greaterThan = ">"
            
        }
        
        public typealias This = Precedence
        
        public let id: String?
        
        /// Magnitude indicating the precedence of a grammar rule. A larger
        /// value indicates a higher precedence.
        public let value: Int?
        
        /// Relation of this precedence with another precedence.
        public let relation: Relation
        
        /// Id of another precendence that this precedence is related to.
        public let reference: String?
        
        /// Constructs a new precedence with an initial value.
        public init(id: String? = nil, _ anyValue: Any? = nil) {
            var intValue = anyValue as? Int ?? 0
            let strValue = anyValue as? String ?? ""
            intValue ?= Int(strValue)
            self.id = id
            self.value = intValue
            var relation: Relation = .none
            var reference: String?
            if let match = "(<=>)\\s*([\\p{L}_][\\p{L}_0-9-]+)".firstMatch(in: strValue) {
                relation = Relation(rawValue: strValue.substring(with: match.range(at: 1))) ?? .none
                reference = strValue.substring(with: match.range(at: 2))
            }
            self.relation = relation
            self.reference = reference
        }
        
        public static func < (lhs: This, rhs: This) -> Bool {
            if let lhs = lhs.value, let rhs = rhs.value {
                if lhs < rhs { return true }
            }
            return
                (lhs.relation == .lessThan && lhs.reference == rhs.id) ||
                (rhs.relation == .greaterThan && rhs.reference == lhs.id)
        }
        
        public static func == (lhs: This, rhs: This) -> Bool {
            if let lhs = lhs.value, let rhs = rhs.value {
                if lhs == rhs { return true }
            }
            return
                (lhs.relation == .equalTo && lhs.reference == rhs.id) ||
                (rhs.relation == .equalTo && rhs.reference == lhs.id)
        }
        
        public static func > (lhs: This, rhs: This) -> Bool {
            if let lhs = lhs.value, let rhs = rhs.value {
                if lhs > rhs { return true }
            }
            return
                (lhs.relation == .greaterThan && lhs.reference == rhs.id) ||
                (rhs.relation == .lessThan && rhs.reference == lhs.id)
        }
        
    }
    
}

extension GrammarRule.Precedence: CustomStringConvertible {
    
    public var description: String {
        return String(format: "%@%@%@",
                      value != nil ? String(format: "%d", value!) : "",
                      relation.rawValue,
                      reference ?? "")
    }
    
}

extension GrammarRule.Precedence: CVarArg {
    
    public var _cVarArgEncoding: [Int] {
        return description._cVarArgEncoding
    }
    
}
