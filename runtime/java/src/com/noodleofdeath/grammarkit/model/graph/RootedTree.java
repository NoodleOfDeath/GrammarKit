package com.noodleofdeath.pastaparser.model.graph;

/**
 * Specifications for a rooted treethat extends {@link RootedNode} and
 * {@link Tree}.
 * 
 * @param <R> the type of the parent, children, and root ancestor of this node.
 */
public interface RootedTree<R extends RootedTree<R>> extends RootedNode<R>, Tree<R> {
}
