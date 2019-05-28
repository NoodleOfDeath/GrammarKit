package com.noodleofdeath.pastaparser.io.parser;

import com.noodleofdeath.pastaparser.io.TokenStream;
import com.noodleofdeath.pastaparser.io.token.Token;
import com.noodleofdeath.pastaparser.model.grammar.Grammar;
import com.noodleofdeath.pastaparser.model.grammar.event.listener.GrammarEventGenerator;
import com.noodleofdeath.pastaparser.model.grammar.event.listener.ParserListener;
import com.noodleofdeath.pastaparser.model.grammar.rule.GrammarRule;
import com.noodleofdeath.pastaparser.model.graph.tree.syntaxtree.ParserSyntaxTree;

/**
 * @param <R>
 */
public interface Parser<R, T extends Token<R>> extends GrammarEventGenerator<ParserListener<R, T>> {

	/** @return */
	public abstract Grammar grammar();

	/**
	 * @param Grammar
	 */
	public abstract void setGrammar(Grammar grammar);

	/**
	 * @param tokenStream
	 */
	public default void parse(TokenStream<R, T> tokenStream) {
		parse(tokenStream, 0);
	}

	/**
	 * @param tokenStream
	 */
	public abstract void parse(TokenStream<R, T> tokenStream, int offset);

	/**
	 * @param tokenStream
	 * @param parserRule
	 * @return
	 */
	public default ParserSyntaxTree<T> parse(TokenStream<R, T> tokenStream, GrammarRule parserRule) {
		return parse(tokenStream, parserRule, 0, null);
	}

	/**
	 * @param tokenStream
	 * @param parserRule
	 * @param offset
	 * @return
	 */
	public default ParserSyntaxTree<T> parse(TokenStream<R, T> tokenStream, GrammarRule parserRule,
			int offset) {
		return parse(tokenStream, parserRule, offset, null);
	};

	/**
	 * @param tokenStream
	 * @param parserRule
	 * @param offset
	 * @param syntaxTree
	 */
	public abstract ParserSyntaxTree<T> parse(TokenStream<R, T> tokenStream, GrammarRule parserRule,
			int offset, ParserSyntaxTree<T> syntaxTree);

}
