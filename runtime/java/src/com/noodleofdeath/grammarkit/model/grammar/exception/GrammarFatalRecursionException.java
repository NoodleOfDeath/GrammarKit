package com.noodleofdeath.pastaparser.model.grammar.exception;

import com.noodleofdeath.pastaparser.model.grammar.rule.GrammarRule;

/**
 * 
 */
public class GrammarFatalRecursionException extends GrammarException {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	/**
	 *
	 * @param rule
	 */
	public GrammarFatalRecursionException(GrammarRule rule) {
		super(String.format("Encountered a fatal recursive rule defined with \"%s\". Skipping this rule.", rule));
	}

}
