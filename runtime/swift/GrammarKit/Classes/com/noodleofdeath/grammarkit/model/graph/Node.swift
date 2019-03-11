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
