package com.noodleofdeath.pastaparser.model.graph;

import com.noodleofdeath.pastaparser.Quantified;

/**
 * Specifications for a grammar tree that extends {@link Tree} and
 * {@link Quantified}.
 * 
 * @param <R> the type of parent and child rules found within this entire
 *        grammar tree.
 */
public interface GrammarTree<R extends GrammarTree<R>> extends RootedTree<R>, Quantified {
}
