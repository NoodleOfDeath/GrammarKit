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

        public typealias This = Metadata
        public typealias NodeType = Metadata

        public static var nodeCount: Int = 0
        
        enum CodingKeys: String, CodingKey {
            case next
            case children
            case baseId
            case id
            case description
            case options
            case categories
            case references
            case directives
        }

        override open var description: String {
            var strings = [String]()
            strings.append("- Options: \(options)")
            strings.append("- Categories: \(categories)")
            if let description = detailedDescription {
                strings.append("- Description: \(description)")
            }
            references.forEach({ strings.append("- Reference: \($0)") })
            directives.forEach({ strings.append("- Directive: \($0)") })
            return strings.joined(separator: "\n")
        }

        // MARK: - Node Properties
        
        open var parent: NodeType? {
            didSet {
                guard let parent = parent else { return }
                id = String(format: "%@.%@", parent.id, baseId)
            }
        }

        // MARK: - Tree Properties

        open var children = [NodeType]() { didSet { updateChildren() } }

        // MARK: - NodeChain Properties

        open var previous: NodeType?
        
        open var next: NodeType? { didSet { updateNext() } }

        // MARK: - Instance Properties

        fileprivate let baseId: String
        
        /// Unique identifier of this metadata.
        public var id: String

        /// Detailed description of this metadata.
        public var detailedDescription: String?
        
        /// Options of this component.
        public var options: [MetadataOption]
        
        /// Categories of this component.
        public var categories: [String]
        
        /// Category of this component.
        public var category: String? { return categories.first }

        /// References of this metadata.
        public var references = [Reference]()

        /// Additional directives for the lexer/parser to handle upon matching.
        public var directives = [Directive]()

        // MARK: - Constructor Methods

        /// Constructs a new metadata instance with a initial, id, options,
        /// categories, attributes, references, and directives.
        ///
        /// - Parameters:
        ///     - id: of this metadata.
        ///     - detailedDescription: of this metadata.
        ///     - options: of this metadata.
        ///     - categories: of this metadata.
        ///     - references: of this metadata.
        ///     - directives: of this metadata.
        public required init(id: String,
                             detailedDescription: String?,
                             options: [MetadataOption],
                             categories: [String],
                             references: [Reference],
                             directives: [Directive]) {
            self.baseId = id
            self.id = id
            self.detailedDescription = detailedDescription
            self.options = options
            self.categories = categories
            self.references = references
            self.directives = directives
            This.nodeCount += 1
        }

        /// Constructs a new metadata instance from a dictionary.
        ///
        /// - Parameters:
        ///     - dict: to load values from.
        public convenience init(from dict: [String: Any]? = nil) {
            let id = dict?[CodingKeys.id] as? String ?? String(This.nodeCount)
            let detailedDescription = dict?[CodingKeys.description] as? String
            let options = (dict?[CodingKeys.options] as? [String])?.map({ MetadataOption($0) }) ?? []
            let categories = (dict?[CodingKeys.categories] as? [String]) ?? []
            let references = (dict?[CodingKeys.references] as? [String])?.map({ Reference(string: $0) }).filter({ $0 != nil }) as? [Reference] ?? []
            let directives = (dict?[CodingKeys.directives] as? [String])?.map({ Directive(string: $0) }).filter({ $0 != nil }) as? [Directive] ?? []
            self.init(id: id,
                      detailedDescription: detailedDescription,
                      options: options,
                      categories: categories,
                      references: references,
                      directives: directives)
        }
        
        public required init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            next = try values.decodeIfPresent(Metadata.self, forKey: .next)
            children = try values.decode([Metadata].self, forKey: .children)
            baseId = try values.decode(String.self, forKey: .baseId)
            id = try values.decode(String.self, forKey: .id)
            detailedDescription = try values.decodeIfPresent(String.self, forKey: .description)
            options = try values.decode([MetadataOption].self, forKey: .options)
            categories = try values.decode([String].self, forKey: .categories)
            references = try values.decode([Reference].self, forKey: .references)
            directives = try values.decode([Directive].self, forKey: .directives)
            super.init()
            updateChildren()
            updateNext()
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encodeIfPresent(next, forKey: .next)
            try container.encode(children, forKey: .children)
            try container.encode(baseId, forKey: .baseId)
            try container.encode(id, forKey: .id)
            try container.encodeIfPresent(detailedDescription, forKey: .description)
            try container.encode(options, forKey: .options)
            try container.encode(categories, forKey: .categories)
            try container.encode(references, forKey: .references)
            try container.encode(directives, forKey: .directives)
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
        
        /// Returns `true` if, and only if, `self.categories` contains any
        /// element in `categories`; `false`, otherwise.
        ///
        /// - Parameters:
        ///     - categories: to test for membership
        /// - Returns: `true` if, and only if, `self.categories` contains any
        /// element in `categories`; `false`, otherwise.
        public func isMemberOf(_ categories: String...) -> Bool {
            return self.categories.first { categories.contains($0) } != nil
        }
        
    }
    
}

// MARK: - Metadata Addition Operations
extension Grammar.Metadata {

    public static func + (lhs: Grammar.Metadata, rhs: Grammar.Metadata) -> Grammar.Metadata {
        lhs.options += rhs.options
        lhs.categories += rhs.categories
        lhs.references += rhs.references
        lhs.directives += rhs.directives
        return lhs
    }

    public static func += (lhs: inout Grammar.Metadata, rhs: Grammar.Metadata) {
        lhs = lhs + rhs
    }

}
