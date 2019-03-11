package com.noodleofdeath.pastaparser.model.graph;

import java.util.HashMap;

public interface HashTree<K, V extends HashTree<K, V>> extends HashNode<K, V> {
	public abstract HashMap<K, V> getChildren();

	public abstract V addChild(K paramK, V paramV);
}
