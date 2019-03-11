package com.noodleofdeath.pastaparser.model.graph.impl;

import java.util.ArrayList;
import java.util.List;

import com.noodleofdeath.pastaparser.model.graph.Tree;

/**
 * Abstract implementation of {@link Tree}.
 * 
 * @param <R> the type of parent and child nodes found within this entire tree.
 */
public abstract class AbstractTree<R extends Tree<R>> extends AbstractNode<R> implements Tree<R> {

	/** Child list of this tree. */
	protected ArrayList<R> children = new ArrayList<>();

	public List<R> children() {
		return children;
	}

	@SuppressWarnings("unchecked")
	public boolean addChild(R child) {
		child.setParent((R) this);
		return children.add(child);
	}

	@SuppressWarnings("unchecked")
	public void addChild(int index, R child) {
		child.setParent((R) this);
		children.add(index, child);
	}

	public boolean removeChild(R child) {
		boolean removed = children.remove(child);
		child.setParent(null);
		return removed;
	}

	public R removeChild(int index) {
		R child = children.remove(index);
		if (child == null)
			return null;
		child.setParent(null);
		return child;
	}

}
