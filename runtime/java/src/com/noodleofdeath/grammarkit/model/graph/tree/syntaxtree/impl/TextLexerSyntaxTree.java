package com.noodleofdeath.pastaparser.model.graph.tree.syntaxtree.impl;

import com.noodleofdeath.pastaparser.io.token.TextToken;
import com.noodleofdeath.pastaparser.io.token.impl.BaseTextToken;
import com.noodleofdeath.pastaparser.model.grammar.Grammar;
import com.noodleofdeath.pastaparser.model.graph.tree.syntaxtree.LexerSyntaxTree;

/**
 * 
 */
public class TextLexerSyntaxTree extends AbstractSyntaxTree<TextToken>
		implements LexerSyntaxTree<String, TextToken> {

	/**
	 * 
	 */
	protected String value = "";

	@Override
	public boolean addToken(TextToken token) {
		value += token.value();
		return super.addToken(token);
	}

	@Override
	public int length() {
		return value.length();
	}

	/**
	 * @return
	 */
	@Override
	public String value() {
		return value;
	}

	@Override
	public TextToken generateToken() {
		if (tokens.size() < 1)
			return null;
		return new BaseTextToken(rule(), value, tokens.get(0).start(), tokens.get(tokens.size() - 1).end());
	}

}
