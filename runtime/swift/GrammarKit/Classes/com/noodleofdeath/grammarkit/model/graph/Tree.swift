//
//  GrammarKit
//
//  Copyright © 2019 NoodleOfDeath. All rights reserved.
//

import Foundation

/// Specifications for a tree.
public protocol Tree: Node where NodeType: Tree {
    
    /// Child nodes of this tree.
    var children: [NodeType] { get set }
    
}

extension Tree {
    
    public subscript (index: Int) -> NodeType {
        get { return children[index] }
        set { children[index] = newValue }
    }
    
    /// Number of children this tree has.
    public var childCount: Int {
        return children.count
    }
    
    /// `true` if this tree has no children; `false`, otherwise.
    public var isLeaf: Bool {
        return children.count == 0
    }
    
    /// Appends a child to the children of this tree.
    /// - parameter child: to append to the children of this tree.
    public func add(child: NodeType) {
        child.parent = self as? NodeType.NodeType
        children.append(child)
    }
    
    /// Inserts a child into the children of this tree at a specified index.
    /// - parameter child: to insert into the children of this tree.
    /// - parameter index: at which to insert the child node.
    public func insert(child: NodeType, at index: Int) {
        child.parent = self as? NodeType.NodeType
        children.insert(child, at: index)
    }
    
    /// Removes a child from the children of this tree at the specified index.
    /// - parameter index: of the child to remove from the children of this
    /// tree.
    public func removeChild(at index: Int) -> NodeType {
        let e = children.remove(at: index)
        e.parent = nil
        return e
    }
    
    /// Associates this node as the parent node for each of its child nodes.
    public func updateChildren() {
        children.forEach {
            $0.parent = self as? NodeType.NodeType
            $0.updateChildren()
        }
    }
    
}

///
public protocol TreeChain: NodeChain, Tree where NodeType: TreeChain {
    
}

extension TreeChain {
    
    /// Associates this node as the previous sibling of its next sibling.
    public func updateNext() {
        next?.previous = self as? NodeType.NodeType
        next?.updateNext()
    }
    
}
