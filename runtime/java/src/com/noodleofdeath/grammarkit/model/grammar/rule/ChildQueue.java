package com.noodleofdeath.pastaparser.model.grammar.rule;

import java.util.List;

import com.noodleofdeath.pastaparser.model.grammar.Grammar;

/**   */
public interface ChildQueue {

	/**
	 * @param rule
	 * @return
	 */
	public abstract boolean enqueue(GrammarRule rule);

	/** @return */
	public abstract List<GrammarRule> queue();

	/**   */
	public abstract void clearQueue();

}
