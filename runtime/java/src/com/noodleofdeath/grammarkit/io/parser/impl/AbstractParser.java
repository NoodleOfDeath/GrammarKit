package com.noodleofdeath.pastaparser.io.parser.impl;

import com.noodleofdeath.pastaparser.io.parser.Parser;
import com.noodleofdeath.pastaparser.io.token.Token;
import com.noodleofdeath.pastaparser.model.grammar.Grammar;
import com.noodleofdeath.pastaparser.model.grammar.event.listener.ParserListener;
import com.noodleofdeath.pastaparser.model.grammar.event.listener.impl.BaseGrammarEventGenerator;

/**
 * @param <R>
 * @param <T>
 */
public abstract class AbstractParser<R, T extends Token<R>> extends BaseGrammarEventGenerator<ParserListener<R, T>>
		implements Parser<R, T> {

	/**   */
	protected Grammar grammar;

	/**  */
	public AbstractParser() {

	}

	/**
	 *
	 * @param Grammar
	 */
	public AbstractParser(Grammar grammar) {
		this.grammar = grammar;
	}

	@Override
	public Grammar grammar() {
		return grammar;
	}

	@Override
	public void setGrammar(Grammar grammar) {
		this.grammar = grammar;
	}

}
