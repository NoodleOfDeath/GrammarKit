package com.noodleofdeath.pastaparser.model.graph.impl;

import com.noodleofdeath.pastaparser.model.graph.HashNode;

public abstract class AbstractHashNode<K, V extends HashNode<K, V>> implements HashNode<K, V> {
	protected V parent = null;

	public V getParent() {
		return parent;
	}

	public void setParent(V parent) {
		this.parent = parent;
	}
}
