package com.noodleofdeath.pastaparser.io.engine.impl;

import com.noodleofdeath.pastaparser.io.lexer.Lexer;
import com.noodleofdeath.pastaparser.io.token.TextToken;

/**
 * Base implementation of a text lexer engine.
 */
public class BaseTextLexerEngine extends AbstractLexerEngine<String, TextToken, Lexer<String, TextToken>> {

	/**
	 *
	 * @param lexer
	 */
	public BaseTextLexerEngine(Lexer<String, TextToken> lexer) {
		super(lexer);
	}

	/**
	 *
	 * @param lexer
	 * @param listener
	 */
	public BaseTextLexerEngine(Lexer<String, TextToken> lexer, boolean listener) {
		super(lexer, listener);
	}

}
