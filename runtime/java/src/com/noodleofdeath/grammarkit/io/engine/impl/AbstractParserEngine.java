package com.noodleofdeath.pastaparser.io.engine.impl;

import com.noodleofdeath.pastaparser.io.engine.ParserEngine;
import com.noodleofdeath.pastaparser.io.parser.Parser;
import com.noodleofdeath.pastaparser.io.token.TextToken;
import com.noodleofdeath.pastaparser.io.token.Token;
import com.noodleofdeath.pastaparser.model.grammar.event.listener.ParserListener;
import com.noodleofdeath.pastaparser.model.grammar.event.listener.impl.BaseGrammarEventGenerator;
import com.noodleofdeath.pastaparser.model.graph.tree.syntaxtree.ParserSyntaxTree;

/**
 * Base implementation of {@link ParserEngine}.
 * 
 * @param <R>
 * @param <T>
 * @param <P>
 */
public abstract class AbstractParserEngine<R, T extends Token<R>, P extends Parser<R, T>>
		extends BaseGrammarEventGenerator<ParserListener<R, T>> implements ParserEngine<R, T, P> {

	/**
	 * 
	 */
	protected Parser<R, T> parser;

	/**
	 *
	 * @param parser
	 */
	public AbstractParserEngine(Parser<R, T> parser) {
		this(parser, true);
	}

	/**
	 *
	 * @param parser
	 * @param listener
	 */
	public AbstractParserEngine(Parser<R, T> parser, boolean listener) {
		this.parser = parser;
		if (listener)
			parser.addGrammarEventListener(this);
	}

	@Override
	public void didGenerateSyntaxTree(Parser<R, T> parser, ParserSyntaxTree<T> syntaxTree) {
	}

	@Override
	public void didSkipToken(Parser<R, T> parser, TextToken token) {
	}

	@Override
	public Parser<R, T> parser() {
		return parser;
	}

}
