package com.noodleofdeath.pastaparser.io.token.impl;

import com.noodleofdeath.pastaparser.io.TokenStream;
import com.noodleofdeath.pastaparser.io.token.Token;

/** @param <R> */
public abstract class AbstractToken<R> implements Token<R> {

	/**   */
	protected R value = null;

	/**   */
	protected TokenStream<R, Token<R>> tokenStream = null;

	/**  */
	public AbstractToken() {

	}

	/**
	 *
	 * @param value
	 */
	public AbstractToken(R value) {
		this.value = value;
	}

	@Override
	public R value() {
		return value;
	}

	@Override
	public void setValue(R value) {
		this.value = value;
	}

	@SuppressWarnings("unchecked")
	@Override
	public <T extends Token<R>> TokenStream<R, T> tokenStream() {
		return (TokenStream<R, T>) tokenStream;
	}

	@SuppressWarnings("unchecked")
	@Override
	public <T extends Token<R>> void setTokenStream(TokenStream<R, T> tokenStream) {
		this.tokenStream = (TokenStream<R, Token<R>>) tokenStream;
	}

}
