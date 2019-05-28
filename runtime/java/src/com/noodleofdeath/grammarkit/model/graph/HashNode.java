package com.noodleofdeath.pastaparser.model.graph;

public interface HashNode<K, V extends HashNode<K, V>> {
	public abstract V getParent();

	public abstract void setParent(V paramV);
}
