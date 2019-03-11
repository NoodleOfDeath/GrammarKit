package com.noodleofdeath.pastaparser.model.graph.impl;

import java.util.ArrayList;
import java.util.List;

import com.noodleofdeath.pastaparser.model.graph.RootedTree;

/**
 * Abstract implementation of {@link RootTree} that extends
 * {@link AbstractRootedNode}.
 * 
 * @param <R> the type of the parent and root ancestor of this node.
 */
public abstract class AbstractRootedTree<R extends RootedTree<R>> extends AbstractRootedNode<R>
		implements RootedTree<R> {

	/** Children of this rooted tree. */
	protected ArrayList<R> children = new ArrayList<>();

	@Override
	public List<R> children() {
		return children;
	}

	@Override
	public void setChildren(List<R> children) {
		this.children = new ArrayList<>(children);
	}

	@Override
	@SuppressWarnings("unchecked")
	public boolean addChild(R child) {
		child.setParent((R) this);
		return children.add(child);
	}

	@Override
	@SuppressWarnings("unchecked")
	public void addChild(int index, R child) {
		child.setParent((R) this);
		children.add(index, child);
	}
	
	@Override
	public boolean removeChild(R child) {
		boolean removed = children.remove(child);
		child.setParent(null);
		return removed;
	}

	@Override
	public R removeChild(int index) {
		R child = children.remove(index);
		if (child == null)
			return null;
		child.setParent(null);
		return child;
	}

}
