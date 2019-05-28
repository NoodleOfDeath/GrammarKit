package com.noodleofdeath.pastaparser.model.grammar.exception;

/**
 * 
 */
public class GrammarInitializationException extends GrammarException {

	private static final long serialVersionUID = 7849579317192830338L;

	/**
	 *
	 */
	public GrammarInitializationException() {
		super(String.format("Missing root \"grammar\" element"));
	}
}
