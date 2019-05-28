package com.noodleofdeath.pastaparser.io.token;

import java.util.List;

import com.noodleofdeath.pastaparser.io.TokenStream;
import com.noodleofdeath.pastaparser.model.grammar.rule.GrammarRule;

/** @param <R> */
public interface Token<R> {

	/** @return */
	public abstract R value();

	/** @param value */
	public abstract void setValue(R value);

	/** @return */
	public abstract GrammarRule lexerRule();

	/** @param lexerRule */
	public abstract void setLexerRule(GrammarRule lexerRule);

	/** @return */
	public abstract GrammarRule parserRule();

	/** @param parserRule */
	public abstract void setParserRule(GrammarRule parserRule);

	/** @return */
	public abstract <T extends Token<R>> TokenStream<R, T> tokenStream();

	/** @param tokenStream */
	public abstract <T extends Token<R>> void setTokenStream(TokenStream<R, T> tokenStream);

	/** @return */
	public abstract List<String> categories();

	/** @return */
	public abstract List<String> options();

}
