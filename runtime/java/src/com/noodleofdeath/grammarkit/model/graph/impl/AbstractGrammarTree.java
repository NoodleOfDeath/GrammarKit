package com.noodleofdeath.pastaparser.model.graph.impl;

import com.noodleofdeath.pastaparser.Quantifier;
import com.noodleofdeath.pastaparser.model.graph.GrammarTree;

/**
 * Abstract implementation of {@link GrammarTree}.
 * 
 * @param <R> the type of parent and child rules found within this entire
 *        grammar tree.
 */
public abstract class AbstractGrammarTree<R extends GrammarTree<R>> extends AbstractRootedTree<R>
		implements GrammarTree<R> {

	/** Quantifier of this grammar tree. */
	protected Quantifier quantifier = Quantifier.Once;

	@Override
	public R rootAncestor() {
		return rootAncestor;
	}

	@Override
	public void setRootAncestor(R rootAncestor) {
		this.rootAncestor = rootAncestor;
	}

	@Override
	public Quantifier quantifier() {
		return quantifier;
	}

	@Override
	public void setQuantifier(Quantifier quantifier) {
		this.quantifier = quantifier;
	}

}
