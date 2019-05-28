package com.noodleofdeath.pastaparser.io.token.impl;

import java.util.ArrayList;
import java.util.List;

import com.noodleofdeath.pastaparser.io.token.TextToken;
import com.noodleofdeath.pastaparser.model.grammar.rule.GrammarRule;

/**   */
public class BaseTextToken extends AbstractToken<String> implements TextToken {

	/**   */
	protected int start = -1;

	/**   */
	protected int end = -1;

	/**   */
	protected GrammarRule lexerRule = null;

	/**   */
	protected GrammarRule parserRule = null;

	/**   */
	protected List<String> categories = new ArrayList<>();

	/**   */
	protected List<String> options = new ArrayList<>();

	/**  */
	public BaseTextToken() {
	}

	/**
	 *
	 * @param value
	 * @param start
	 * @param end
	 */
	public BaseTextToken(GrammarRule lexerRule, String value, int start, int end) {
		super(value);
		this.lexerRule = lexerRule;
		this.start = start;
		this.end = end;
	}

	@Override
	public String toString() {
		return String.format("%s: \"%s\" (%d, %d)[%d]", lexerRule().id(), text(StringOptionEscaped), start(), end(),
				length());
	}

	@Override
	public int start() {
		return start;
	}

	@Override
	public int end() {
		return end;
	}

	@Override
	public void setStart(int start) {
		this.start = start;
	}

	@Override
	public void setEnd(int end) {
		this.end = end;
	}

	@Override
	public GrammarRule lexerRule() {
		return lexerRule;
	}

	@Override
	public void setLexerRule(GrammarRule lexerRule) {
		this.lexerRule = lexerRule;
		categories = lexerRule.categories();
		options = lexerRule.options();
	}

	@Override
	public GrammarRule parserRule() {
		return parserRule;
	}

	@Override
	public void setParserRule(GrammarRule parserRule) {
		this.parserRule = parserRule;
	}

	@Override
	public List<String> categories() {
		return categories;
	}

	@Override
	public List<String> options() {
		return options;
	}

}
