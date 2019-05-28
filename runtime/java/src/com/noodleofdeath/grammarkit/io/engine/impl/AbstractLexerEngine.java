package com.noodleofdeath.pastaparser.io.engine.impl;

import com.noodleofdeath.pastaparser.io.engine.LexerEngine;
import com.noodleofdeath.pastaparser.io.lexer.Lexer;
import com.noodleofdeath.pastaparser.io.token.Token;
import com.noodleofdeath.pastaparser.model.grammar.event.listener.LexerListener;
import com.noodleofdeath.pastaparser.model.grammar.event.listener.impl.BaseGrammarEventGenerator;
import com.noodleofdeath.pastaparser.model.graph.tree.syntaxtree.LexerSyntaxTree;

/**
 * Base implementation of {@link LexerEngine}.
 * 
 * @param <R>
 * @param <T>
 * @param <L>
 */
public abstract class AbstractLexerEngine<R, T extends Token<R>, L extends Lexer<R, T>>
		extends BaseGrammarEventGenerator<LexerListener<R, T>> implements LexerEngine<R, T, L> {

	/**
	 * 
	 */
	protected Lexer<R, T> lexer;

	/**
	 *
	 * @param lexer
	 */
	public AbstractLexerEngine(Lexer<R, T> lexer) {
		this(lexer, true);
	}

	/**
	 *
	 * @param lexer
	 * @param listener
	 */
	public AbstractLexerEngine(Lexer<R, T> lexer, boolean listener) {
		this.lexer = lexer;
		if (listener)
			lexer.addGrammarEventListener(this);
	}

	@Override
	public void didGenerateSyntaxTree(Lexer<R, T> lexer, LexerSyntaxTree<R, T> syntaxTree) {

	}

	@Override
	public void didNotMatchToken(Lexer<R, T> lexer, T token) {

	}

	@Override
	public Lexer<R, T> lexer() {
		return lexer;
	}

}
