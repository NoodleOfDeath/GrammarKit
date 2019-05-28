package com.noodleofdeath.pastaparser.model.grammar.event.listener;

import com.noodleofdeath.pastaparser.io.parser.Parser;
import com.noodleofdeath.pastaparser.io.token.TextToken;
import com.noodleofdeath.pastaparser.io.token.Token;
import com.noodleofdeath.pastaparser.model.graph.tree.syntaxtree.ParserSyntaxTree;

public interface ParserListener<R, T extends Token<R>> extends GrammarListener {

	/**
	 * @param parser
	 * @param syntaxTree
	 */
	public abstract void didGenerateSyntaxTree(Parser<R, T> parser, ParserSyntaxTree<T> syntaxTree);

	/**
	 * @param parser
	 * @param syntaxTree
	 */
	public abstract void didSkipToken(Parser<R, T> parser, TextToken token);

}