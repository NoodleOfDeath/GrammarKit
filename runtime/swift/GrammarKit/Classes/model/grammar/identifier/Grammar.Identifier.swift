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

import UIKit

extension Grammar {

    /// Data structure that represents a grammatical range found in a grammar
    /// that can be indexed.
    open class Identifier: DocumentReference {
        
        public typealias This = Identifier
        
        public enum CodingKeys: String, CodingKey {
            case url
            case string
            case type
            case detailedDescription
            case metadata
        }
        
        override open var description: String {
            return String(describing: string)
        }
        
        // MARK: - Instance Properties
        
        /// Summary of this identifier.
        open var detailedDescription: String?
        
        /// Type of this identifier.
        open var type: String?
        
        /// Type of this identifier
        open lazy var metadata: Metadata = Metadata()
        
        // MARK: - Constructor Methods
        
        /// Constructs a new identifer.
        public convenience init(document: UIDocument? = nil, start: Int = 0, lineNumber: Int = 0, string: String, type: String? = nil, detailedDescription: String? = nil, metadata: Metadata? = nil) {
            self.init(start: start, length: string.length, string: string)
            self.document = document
            self.type = type
            self.detailedDescription = detailedDescription
            self.metadata = metadata ?? Metadata()
        }
        
    }

}
