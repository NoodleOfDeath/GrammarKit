package com.noodleofdeath.pastaparser.io.impl;

import java.util.ArrayList;
import java.util.List;

import com.noodleofdeath.pastaparser.io.TokenStream;
import com.noodleofdeath.pastaparser.io.token.Token;

/** @param <R> */
public class BaseTokenStream<R, T extends Token<R>> implements TokenStream<R, T> {

	/**   */
	protected List<T> tokens = new ArrayList<>();

	@Override
	public int length() {
		return tokens.size();
	}

	@Override
	public T get(int index) {
		return tokens.get(index);
	}

	@Override
	public boolean addToken(T token) {
		return tokens.add(token);
	}

	@Override
	public T removeToken(int cursor) {
		return tokens.remove(cursor);
	}

	@Override
	public boolean removeToken(T token) {
		return tokens.remove(token);
	}

}
