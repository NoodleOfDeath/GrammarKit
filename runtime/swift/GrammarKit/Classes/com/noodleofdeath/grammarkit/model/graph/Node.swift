//
//  GrammarKit
//
//  Copyright © 2019 NoodleOfDeath. All rights reserved.
//

import Foundation

/// Specifications for a node.
public protocol Node: NSObjectProtocol {
    
    /// Type used of the ancestor nodes of this node.
    associatedtype NodeType: Any
    
    /// Returns `true` if, and only if, this node has no parent node; `false`,
    /// otherwise.
    var isRoot: Bool { get }
    
    /// Root ancestor of this node, if one exists.
    var rootAncestor: NodeType? { get }
    
    /// Direct parent ancestor of this node, if one exists.
    var parent: NodeType? { get set }
    
    /// Depth of this node. A value of `1` indicates that this is a root node.
    var depth: Int { get }
    
}

extension Node where NodeType: Node, NodeType == NodeType.NodeType {
    
    public var isRoot: Bool {
        return parent == nil
    }
    
    public var rootAncestor: NodeType? {
        return parent?.rootAncestor ?? parent
    }
    
    public var depth: Int {
        return (parent?.depth ?? 0) + 1
    }
    
}

/// Specification of a node chain.
public protocol NodeChain: Node where NodeType: NodeChain {
    
    /// Sibling node that precedes this node, if one exists. Also called an
    /// older sibling.
    var previous: NodeType? { get set }
    
    /// Sibling node that follows this node, if one exists. Also called a
    /// younger sibling.
    var next: NodeType? { get set }
    
}
