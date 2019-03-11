//
//  PastaParser
//
//  Copyright © 2019 NoodleOfDeath. All rights reserved.
//

import Foundation

extension Grammar {
    
    ///
    @objc(Metadata)
    open class Metadata: NSObject, TreeChain, Codable {
        
        enum CodingKeys: String, CodingKey {
            case next
            case children
            case id
            case options
            case categories
            case attributes
        }
        
        override open var description: String {
            var description = String(format: "%@: %@, %@", id, options.debugDescription, categories.debugDescription)
            if children.count > 0 {
                var strings = [String]()
                children.forEach { strings.append($0.description) }
                description += String(format: " (%@)", strings.joined(separator: " | "))
            }
            if let next = next { description += String(format: " -> %@", next) }
            return description.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        public typealias NodeType = Metadata
        
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
        public let options: [MetadataOption]
        
        /// Categories of this component.
        public let categories: [TokenCategory]
        
        /// Category of this component.
        public var category: TokenCategory? { return categories.first }
        
        /// Attributes of this metadata.
        public let attributes: [String: String]
        
        // MARK: - Constructor Methods
        
        ///
        ///
        /// - Parameters:
        ///     - options:
        ///     - categories:
        ///     - id:
        ///     - attributes:
        public required init(id: String? = nil,
                             options: [MetadataOption]? = nil,
                             categories: [TokenCategory]? = nil,
                             attributes: [String: String]? = nil) {
            self.id = id ?? ""
            self.options = options ?? []
            self.categories = categories ?? []
            self.attributes = attributes ?? [:]
        }
        
        public required init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            next = try values.decodeIfPresent(Metadata.self, forKey: CodingKeys.next)
            children = try values.decode([Metadata].self, forKey: CodingKeys.children)
            id = try values.decode(String.self, forKey: CodingKeys.id)
            options = try values.decode([MetadataOption].self, forKey: CodingKeys.options)
            categories = try values.decode([TokenCategory].self, forKey: CodingKeys.categories)
            attributes = try values.decode([String: String].self, forKey: CodingKeys.attributes)
            super.init()
            updateChildren()
            updateNext()
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encodeIfPresent(next, forKey: .next)
            try container.encode(children, forKey: .children)
            try container.encode(id, forKey: CodingKeys.id)
            try container.encode(options, forKey: CodingKeys.options)
            try container.encode(categories, forKey: CodingKeys.categories)
            try container.encode(attributes, forKey: CodingKeys.attributes)
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
        public func isMemberOf(_ categories: TokenCategory...) -> Bool {
            return self.categories.first { categories.contains($0) } != nil
        }
        
    }
    
}
