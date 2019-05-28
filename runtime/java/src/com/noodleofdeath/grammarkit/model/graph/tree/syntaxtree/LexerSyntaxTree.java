package com.noodleofdeath.pastaparser.model.graph.tree.syntaxtree;

import com.noodleofdeath.pastaparser.io.token.TextToken;
import com.noodleofdeath.pastaparser.model.grammar.Grammar;

/**
 * @param <R>
 */
public interface LexerSyntaxTree<R, T> extends SyntaxTree<T> {

	/**
	 * @return
	 */
	public abstract int length();

	/**
	 * @return
	 */
	public abstract R value();

	/**
	 * @return
	 */
	public abstract TextToken generateToken();

}
