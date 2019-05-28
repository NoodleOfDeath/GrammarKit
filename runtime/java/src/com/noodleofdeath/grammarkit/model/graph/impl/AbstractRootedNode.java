package com.noodleofdeath.pastaparser.model.graph.impl;

import com.noodleofdeath.pastaparser.model.graph.RootedNode;

/**
 * Abstract implementation of {@link RootedNode}.
 * 
 * @param <R> the type of the parent and root ancestor of this node.
 */
public abstract class AbstractRootedNode<R extends RootedNode<R>> extends AbstractNode<R> implements RootedNode<R> {

	/** Root ancestor of this rooted tree. */
	protected R rootAncestor = null;

	@Override
	public R rootAncestor() {
		return rootAncestor;
	}

	@Override
	public void setRootAncestor(R rootAncestor) {
		this.rootAncestor = rootAncestor;
	}

}
