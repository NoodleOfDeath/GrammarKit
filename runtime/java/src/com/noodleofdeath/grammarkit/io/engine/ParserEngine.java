package com.noodleofdeath.pastaparser.io.engine;

import com.noodleofdeath.pastaparser.io.TokenStream;
import com.noodleofdeath.pastaparser.io.parser.Parser;
import com.noodleofdeath.pastaparser.io.token.Token;
import com.noodleofdeath.pastaparser.model.grammar.event.listener.ParserListener;
import com.noodleofdeath.pastaparser.model.grammar.rule.GrammarRule;
import com.noodleofdeath.pastaparser.model.graph.tree.syntaxtree.ParserSyntaxTree;

/**
 * Specifications for a parsing engine.
 * 
 * @param <R>
 * @param <T>
 * @param <P>
 */
public interface ParserEngine<R, T extends Token<R>, P extends Parser<R, T>> extends ParserListener<R, T> {

	/**
	 * @return
	 */
	public abstract Parser<R, T> parser();

	/** @param tokenStream */
	public default void parse(TokenStream<R, T> tokenStream) {
		parser().parse(tokenStream);
	}

	/**
	 * @param tokenStream
	 * @param parserRule
	 * @param offset
	 * @param offset_dx
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
	 * @param offset_dx
	 * @param syntaxTree
	 */
	public default ParserSyntaxTree<T> parse(TokenStream<R, T> tokenStream, GrammarRule parserRule,
			int offset, ParserSyntaxTree<T> syntaxTree) {
		return parser().parse(tokenStream, parserRule, offset, syntaxTree);
	}

}
