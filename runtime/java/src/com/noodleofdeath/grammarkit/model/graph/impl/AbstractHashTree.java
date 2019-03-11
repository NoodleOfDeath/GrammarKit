package com.noodleofdeath.pastaparser.model.graph.impl;

import java.util.HashMap;
import java.util.LinkedHashMap;

import com.noodleofdeath.pastaparser.model.graph.HashTree;

public abstract class AbstractHashTree<K, V extends HashTree<K, V>> extends AbstractHashNode<K, V>
		implements HashTree<K, V> {
	private HashMap<K, V> children = new LinkedHashMap<>();

	public HashMap<K, V> getChildren() {
		return children;
	}

	public V addChild(K key, V child) {
		return children.put(key, child);
	}
}
