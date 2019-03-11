package com.noodleofdeath.pastaparser.model.grammar.event.listener;

import java.util.List;

/**
 * @param <Grammar> type of grammar associated with this match tree.
 * @param <R> type of the parent, children, and root ancestor of this node.
 */
public interface GrammarEventGenerator<R extends GrammarListener> {

	/** @return */
	public abstract List<R> listeners();

	/**
	 * @param listener
	 * @return
	 */
	public abstract boolean addGrammarEventListener(R listener);

	/**
	 * @param listener
	 * @return
	 */
	public abstract boolean removeGrammarEventListener(R listener);

	/** @return */
	public abstract void removeAllGrammarEventListeners();

}
