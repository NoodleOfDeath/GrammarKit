package com.noodleofdeath.pastaparser.model.graph;

/**
 * Specifications for a rooted nodethat extends {@link Node}.
 * 
 * @param <R> the type of the parent and root ancestor of this node.
 */
public interface RootedNode<R extends RootedNode<R>> extends Node<R> {

	/**
	 * Gets the root ancestor of this rooted node, if one exists.
	 * 
	 * @return root ancestor of this rooted node, if one exists.
	 */
	public abstract R rootAncestor();

	/**
	 * Sets the root ancestor of this rooted node, if one exists.
	 * 
	 * @param rootAncestor to set for this rooted node.
	 */
	public abstract void setRootAncestor(R rootAncestor);

}
