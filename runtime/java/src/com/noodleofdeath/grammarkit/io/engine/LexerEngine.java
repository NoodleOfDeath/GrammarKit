package com.noodleofdeath.pastaparser.io.engine;

import com.noodleofdeath.pastaparser.io.TokenStream;
import com.noodleofdeath.pastaparser.io.lexer.Lexer;
import com.noodleofdeath.pastaparser.io.token.TextToken;
import com.noodleofdeath.pastaparser.io.token.Token;
import com.noodleofdeath.pastaparser.model.grammar.event.listener.LexerListener;
import com.noodleofdeath.pastaparser.model.grammar.Grammar;
import com.noodleofdeath.pastaparser.model.grammar.rule.GrammarRule;
import com.noodleofdeath.pastaparser.model.graph.tree.syntaxtree.LexerSyntaxTree;

/**
 * Specifications for a lexer engine.
 * 
 * @param <R>
 * @param <T>
 * @param <L>
 */
public interface LexerEngine<R, T extends Token<R>, L extends Lexer<R, T>> extends LexerListener<R, T> {

	/**
	 * @return
	 */
	public abstract Lexer<R, T> lexer();

	/**
	 * @param characterStream
	 * @return
	 */
	public default TokenStream<String, TextToken> tokenize(CharSequence characterStream) {
		return lexer().tokenize(characterStream, 0);
	}

	/**
	 * @param characterStream
	 * @param lexerRule
	 */
	public default LexerSyntaxTree<R, T> tokenize(CharSequence characterStream, GrammarRule lexerRule) {
		return tokenize(characterStream, lexerRule, 0, null);
	}

	/**
	 * @param characterStream
	 * @param lexerRule
	 * @param offset
	 * @param syntaxTree
	 */
	public default LexerSyntaxTree<R, T> tokenize(CharSequence characterStream, GrammarRule lexerRule,
			int offset, LexerSyntaxTree<R, T> syntaxTree) {
		return lexer().tokenize(characterStream, lexerRule, offset, syntaxTree);
	}

}
