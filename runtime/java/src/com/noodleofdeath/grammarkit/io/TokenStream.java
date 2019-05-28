package com.noodleofdeath.pastaparser.io;

import java.util.Collection;
import java.util.List;

import com.noodleofdeath.pastaparser.io.token.Token;

/**
 * Specifications for a token stream.
 * 
 * @param <R> raw type used when parsing tokens.
 * @param <T> implementing token class that uses raw type <code>R</code>.
 */
public interface TokenStream<R, T extends Token<R>> {

	/**
	 * @return
	 */
	public abstract int length();

	/**
	 * @param cursor
	 * @param index
	 * @return
	 */
	public abstract T get(int index);

	/**
	 * Appends a single token to the end of the token collection of this token
	 * stream.
	 * 
	 * @param token to append to the end of the token collection of this token
	 *              stream.
	 * @return <code>true</code> (as specified by {@link Collection#add}).
	 */
	public abstract boolean addToken(T token);

	/**
	 * Inserts a single token at the specified index into the token collection of
	 * this token stream.
	 * 
	 * @param index at which to insert the token into the token collection of this
	 *              token stream.
	 * @param token to insert into the token collection of this token stream.
	 */
	public default void addTokens(List<T> tokens) {
		for (T token : tokens)
			addToken(token);
	}

	/**
	 * Removes a single token at the specified index from the token collection of
	 * this token stream.
	 * 
	 * @param index of the token to remove from the token collection of this token
	 *              stream.
	 * @return token that was removed from the token collection of this token
	 *         stream.
	 */
	public abstract T removeToken(int index);

	/**
	 * Removes the first instance of a token from the token collection of this token
	 * stream
	 * 
	 * @param token to remove from the token collection of this token stream.
	 * @return <code>true</code> (as specified by {@link Collection#remove(T)}).
	 */
	public abstract boolean removeToken(T token);

}
