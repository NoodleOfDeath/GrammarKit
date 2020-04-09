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
    
    /// Data structure for metadata relating to a grammar rules.
    open class Metadata: NSObject, TreeChain, Codable {
        
        public typealias NodeType = Metadata
        
        enum CodingKeys: String, CodingKey {
            case next
            case children
            case id
            case options
            case categories
            case attributes
            case references
        }
        
        override open var description: String {
            var description = String(format: "%@: %@, %@", id, options.debugDescription, categories.debugDescription)
            if count > 0 {
                var strings = [String]()
                children.forEach { strings.append($0.description) }
                description += String(format: " (%@)", strings.joined(separator: " | "))
            }
            if let next = next { description += String(format: " -> %@", next) }
            return description.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        open var parent: NodeType?
        
        open var previous: NodeType?
        
        open var next: NodeType? {
            didSet { updateNext() }
        }
        
        open var children = [NodeType]() {
            didSet { updateChildren() }
        }
        
        /// Unique identifier of this metadata group.
        public let id: String
        
        /// Options of this component.
        public var options: [MetadataOption]
        
        /// Categories of this component.
        public var categories: [String]
        
        /// Category of this component.
        public var category: String? { return categories.first }
        
        /// Attributes of this metadata.
        public var attributes: [String: String]

        /// References
        public var references = [URL]()
        
        // MARK: - Constructor Methods
        
        ///
        ///
        /// - Parameters:
        ///     - id:
        ///     - options:
        ///     - categories:
        ///     - attributes:
        ///     - references:
        public required init(id: String? = nil,
                             options: [MetadataOption]? = nil,
                             categories: [String]? = nil,
                             attributes: [String: String]? = nil,
                             references: [URL]? = nil) {
            self.id = id ?? ""
            self.options = options ?? []
            self.categories = categories ?? []
            self.attributes = attributes ?? [:]
            self.references = references ?? []
        }
        
        public required init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            next = try values.decodeIfPresent(Metadata.self, forKey: .next)
            children = try values.decode([Metadata].self, forKey: .children)
            id = try values.decode(String.self, forKey: .id)
            options = try values.decode([MetadataOption].self, forKey: .options)
            categories = try values.decode([String].self, forKey: .categories)
            attributes = try values.decode([String: String].self, forKey: .attributes)
            references = try values.decode([URL].self, forKey: .references)
            super.init()
            updateChildren()
            updateNext()
        }

        public static func + (lhs: Metadata, rhs: Metadata) -> Metadata {
            lhs.options += rhs.options
            lhs.categories += rhs.categories
            lhs.attributes += rhs.attributes
            lhs.references += rhs.references
            return lhs
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encodeIfPresent(next, forKey: .next)
            try container.encode(children, forKey: .children)
            try container.encode(id, forKey: .id)
            try container.encode(options, forKey: .options)
            try container.encode(categories, forKey: .categories)
            try container.encode(attributes, forKey: .attributes)
            try container.encode(references, forKey: .references)
        }
        
        // MARK: - Instance Methods
        
        /// Returns `true` if, and only if, `options` contains `option`; `false`,
        /// otherwise.
        ///
        /// - Parameters:
        ///     - option: to test.
        /// - Returns: `true` if, and only if, `options` contains `option`; `false`,
        /// otherwise.
        public func has(option: MetadataOption) -> Bool {
            return options.contains(option)
        }
        
        /// Returns `true` if, and only if, `options` contains `option`; `false`,
        /// otherwise.
        ///
        /// - Parameters:
        ///     - option: to test.
        /// - Returns: `true` if, and only if, `options` contains `option`; `false`,
        /// otherwise.
        public func has(option: MetadataOption.RawValue) -> Bool {
            return options.contains(MetadataOption(option))
        }
        
        ///
        ///
        /// - Parameters:
        ///     - categories: to test for membership
        /// - Returns:
        public func isMemberOf(_ categories: String...) -> Bool {
            return self.categories.first { categories.contains($0) } != nil
        }
        
    }
    
}
