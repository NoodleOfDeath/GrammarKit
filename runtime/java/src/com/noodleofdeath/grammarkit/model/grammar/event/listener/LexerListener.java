package com.noodleofdeath.pastaparser.model.grammar.event.listener;

import com.noodleofdeath.pastaparser.io.lexer.Lexer;
import com.noodleofdeath.pastaparser.io.token.Token;
import com.noodleofdeath.pastaparser.model.graph.tree.syntaxtree.LexerSyntaxTree;

public interface LexerListener<R, T extends Token<R>> extends GrammarListener {

	/**
	 * @param lexer
	 * @param syntaxTree
	 */
	public abstract void didGenerateSyntaxTree(Lexer<R, T> lexer, LexerSyntaxTree<R, T> syntaxTree);

	/**
	 * @param lexer
	 * @param token
	 */
	public abstract void didNotMatchToken(Lexer<R, T> lexer, T token);

}
