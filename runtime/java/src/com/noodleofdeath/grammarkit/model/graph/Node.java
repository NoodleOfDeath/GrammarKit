package com.noodleofdeath.pastaparser.model.graph;

/**
 * Specifications for a node.
 * 
 * @param <R> the type of the parent of this node.
 */
public interface Node<R extends Node<R>> {

	/**
	 * <code>true</code> if this node has no parent node; <code>false</code>, otherwise.
	 * 
	 * @return <code>true</code> if this node has no parent node; <code>false</code>,
	 *         otherwise.
	 */
	public default boolean isRoot() {
		return parent() == null;
	}

	/**
	 * Gets the parent node of this node, if one exists.
	 * 
	 * @return parent node of this node, if one exists.
	 */
	public abstract R parent();

	/**
	 * Sets the parent node of this node.
	 * 
	 * @param parent node to set as the parent of this node.
	 */
	public abstract void setParent(R parent);

}
