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
        
        public typealias This = Precedence
        
        public let id: String
        
        /// Magnitude indicating the precedence of a grammar rule. A larger
        /// value indicates a higher precedence.
        public var weight: Int?

        /// Precedence relationships of this grammar rule.
        public var relations = [String: ComparisonResult]()
        
        /// Constructs a new precedence with an initial value.
        public init(id: String, _ precedence: String = "min") {
            self.id = id
            for string in precedence.components(separatedBy: ",") {
                if let weight = Int(string) {
                    self.weight = weight
                    continue
                } else if string == "min" {
                    self.weight = .min
                    continue
                } else if string == "max" {
                    self.weight = .max
                }
                if let match = "([<=>])?\\s*([\\p{L}_][\\p{L}_0-9-]*)\\s*(?:([-+])\\s*([0-9]+))?".firstMatch(in: string) {
                    relations[string.substring(with: match.range(at: 2))] = ComparisonResult(string.substring(with: match.range(at: 1)))
                }
            }
        }
        
    }
    
}

extension GrammarRule.Precedence: CustomStringConvertible {

    public var description: String {
        var strings = [String]()
        if let weight = weight {
            strings.append(String(weight))
        }
        for relation in relations {
            strings.append("\(relation.1)\(relation.0)")
        }
        return strings.joined(separator: ", ")
    }

}
extension GrammarRule.Precedence: CVarArg {

    public var _cVarArgEncoding: [Int] {
        return description._cVarArgEncoding
    }

}
