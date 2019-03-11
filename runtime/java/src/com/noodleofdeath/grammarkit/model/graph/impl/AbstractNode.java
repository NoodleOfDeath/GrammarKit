package com.noodleofdeath.pastaparser.model.graph.impl;

import com.noodleofdeath.pastaparser.model.graph.Node;

/**
 * Abstract implementation of {@link Node}.
 * 
 * @param <R> the type of the parent of this node.
 */
public class AbstractNode<R extends Node<R>> implements Node<R> {

	/** Parent of this node, if one exists. */
	protected R parent = null;

	public R parent() {
		return parent;
	}

	public void setParent(R parent) {
		this.parent = parent;
	}

}
