package com.noodleofdeath.pastaparser.io.engine.impl;

import com.noodleofdeath.pastaparser.io.parser.Parser;
import com.noodleofdeath.pastaparser.io.token.TextToken;

/**
 * Base implementation of a text parser engine.
 */
public class BaseTextParserEngine extends AbstractParserEngine<String, TextToken, Parser<String, TextToken>> {

	/**
	 *
	 * @param parser
	 */
	public BaseTextParserEngine(Parser<String, TextToken> parser) {
		super(parser);
	}

	/**
	 *
	 * @param parser
	 * @param listener
	 */
	public BaseTextParserEngine(Parser<String, TextToken> parser, boolean listener) {
		super(parser, listener);
	}

}
