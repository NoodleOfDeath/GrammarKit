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

/// Specifications for a tree.
public protocol Tree: Node where NodeType: Tree {
    
    /// Child nodes of this tree.
    var children: [NodeType] { get set }
    
}

extension Tree {
    
    /// Subscript indexed get/set access to the children of this tree.
    public subscript (index: Int) -> NodeType {
        get { return children[index] }
        set { children[index] = newValue }
    }
    
    /// Number of children this tree has.
    public var count: Int {
        return children.count
    }
    
    /// `true` if this tree has no children; `false`, otherwise.
    public var isLeaf: Bool {
        return children.count == 0
    }
    
    // MARK: - Instance Methods
    
    /// Appends a child to the children of this tree.
    ///
    /// - Parameters:
    ///     - child: to append to the children of this tree.
    public func add(child: NodeType) {
        child.parent = self as? NodeType.NodeType
        children.append(child)
    }
    
    /// Inserts a child into the children of this tree at a specified index.
    ///
    /// - Parameters:
    ///     - child: to insert into the children of this tree.
    ///     - index: at which to insert the child node.
    public func insert(child: NodeType, at index: Int) {
        child.parent = self as? NodeType.NodeType
        children.insert(child, at: index)
    }
    
    /// Removes and returns the child of this tree at the specified index.
    ///
    /// - Parameters:
    ///     - index: of the child to remove from this tree.
    /// - Returns: the child of this tree at the specified index.
    @discardableResult
    public func removeChild(at index: Int) -> NodeType {
        let e = children.remove(at: index)
        e.parent = nil
        return e
    }
    
    /// Associates this node as the parent node for each of its child nodes.
    /// This method should be invoked anytime `children` has been directly set.
    public func updateChildren() {
        children.forEach {
            $0.parent = self as? NodeType.NodeType
            $0.updateChildren()
        }
    }
    
}

/// Specifications for a chain of tree nodes.
public protocol TreeChain: NodeChain, Tree where NodeType: TreeChain {}

extension TreeChain {
    
    /// Associates this node as the previous sibling of its next sibling.
    /// This method should be invoked anytime `next` has been set.
    public func updateNext() {
        next?.previous = self as? NodeType.NodeType
        next?.updateNext()
    }
    
}
