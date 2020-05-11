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
            case groups
            case references
        }

        override open var description: String {
            var strings = [String]()
            strings.append("- Options: \(options)")
            groups.forEach({ strings.append("- Group: \($0.key) = \($0.value.options)")})
            if let description = detailedDescription {
                strings.append("- Description: \(description)")
            }
            references.forEach({ strings.append("- Reference: \($0)") })
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

        /// groups of this component.
        public var groups: [String: Metadata]
        
        /// References of this metadata.
        public var references = [Reference]()

        // MARK: - Constructor Methods

        /// Constructs a new metadata instance with a initial, id, options,
        /// categories, attributes, references, and directives.
        ///
        /// - Parameters:
        ///     - id: of this metadata.
        ///     - detailedDescription: of this metadata.
        ///     - options: of this metadata.
        ///     - references: of this metadata.
        public required init(id: String,
                             detailedDescription: String?,
                             options: [MetadataOption],
                             groups: [String: Metadata],
                             references: [Reference]) {
            self.baseId = id
            self.id = id
            self.detailedDescription = detailedDescription
            self.options = options
            self.groups = groups
            self.references = references
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
            var groups = [String: Metadata]()
            if let subopts = (dict?[CodingKeys.groups] as? [String: [String: Any]]) {
                subopts.forEach({ groups[$0.key] = Metadata(from: $0.value) })
            }
            let references = (dict?[CodingKeys.references] as? [String])?.map({ Reference(string: $0) }).filter({ $0 != nil }) as? [Reference] ?? []
            self.init(id: id,
                      detailedDescription: detailedDescription,
                      options: options,
                      groups: groups,
                      references: references)
        }
        
        public required init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            next = try values.decodeIfPresent(Metadata.self, forKey: .next)
            children = try values.decode([Metadata].self, forKey: .children)
            baseId = try values.decode(String.self, forKey: .baseId)
            id = try values.decode(String.self, forKey: .id)
            detailedDescription = try values.decodeIfPresent(String.self, forKey: .description)
            options = try values.decode([MetadataOption].self, forKey: .options)
            groups = try values.decode([String: Metadata].self, forKey: .options)
            references = try values.decode([Reference].self, forKey: .references)
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
            try container.encode(groups, forKey: .groups)
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
        
    }
    
}

// MARK: - Metadata Addition Operations
extension Grammar.Metadata {

    public static func + (lhs: Grammar.Metadata, rhs: Grammar.Metadata) -> Grammar.Metadata {
        lhs.options += rhs.options
        lhs.references += rhs.references
        return lhs
    }

    public static func += (lhs: inout Grammar.Metadata, rhs: Grammar.Metadata) {
        lhs = lhs + rhs
    }

}
