package com.noodleofdeath.pastaparser.io.engine.impl;

import com.noodleofdeath.pastaparser.io.engine.LexerEngine;
import com.noodleofdeath.pastaparser.io.engine.ParserEngine;
import com.noodleofdeath.pastaparser.io.engine.SyntaxEngine;
import com.noodleofdeath.pastaparser.io.lexer.Lexer;
import com.noodleofdeath.pastaparser.io.parser.Parser;
import com.noodleofdeath.pastaparser.io.token.TextToken;
import com.noodleofdeath.pastaparser.io.token.Token;
import com.noodleofdeath.pastaparser.model.graph.tree.syntaxtree.LexerSyntaxTree;
import com.noodleofdeath.pastaparser.model.graph.tree.syntaxtree.ParserSyntaxTree;

/**
 * Abstract implementation of a syntax engine.
 * 
 * @param <R>
 * @param <T>
 * @param <L>
 * @param <P>
 */
public abstract class AbstractSyntaxEngine<R, T extends Token<R>, L extends Lexer<R, T>, P extends Parser<R, T>>
		implements SyntaxEngine<R, T, L, P> {

	protected boolean verbose = false;

	/**
	 * 
	 */
	protected LexerEngine<R, T, Lexer<R, T>> lexerEngine;
	/**
	 * 
	 */
	protected ParserEngine<R, T, Parser<R, T>> parserEngine;

	/**
	 * 
	 */
	protected Parser<R, T> parser;

	/**
	 *
	 * @param lexerEngine
	 * @param parserEngine
	 */
	public AbstractSyntaxEngine(LexerEngine<R, T, Lexer<R, T>> lexerEngine,
			ParserEngine<R, T, Parser<R, T>> parserEngine) {
		lexerEngine.lexer().addGrammarEventListener(this);
		parserEngine.parser().addGrammarEventListener(this);
		this.lexerEngine = lexerEngine;
		this.parserEngine = parserEngine;
	}

	@Override
	public void didGenerateSyntaxTree(Lexer<R, T> lexer, LexerSyntaxTree<R, T> syntaxTree) {
		if (verbose)
			System.out.println(String.format("Lexer did generate syntax tree: %s", syntaxTree));
	}

	@Override
	public void didNotMatchToken(Lexer<R, T> lexer, T token) {
		if (verbose)
			System.out.println(String.format("Lexer did not match: %s", token));
	}

	@Override
	public void didGenerateSyntaxTree(Parser<R, T> parser, ParserSyntaxTree<T> syntaxTree) {
		if (verbose)
			System.out.println(String.format("Parser did generate syntax tree: %s", syntaxTree));
	}

	@Override
	public void didSkipToken(Parser<R, T> parser, TextToken token) {
		if (verbose)
			System.out.println(String.format("Parser did skip token: %s", token));
	}

}
