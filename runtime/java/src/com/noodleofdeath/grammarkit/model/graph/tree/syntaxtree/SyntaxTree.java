package com.noodleofdeath.pastaparser.model.graph.tree.syntaxtree;

import java.util.List;

import com.noodleofdeath.pastaparser.model.grammar.Grammar;
import com.noodleofdeath.pastaparser.model.grammar.rule.GrammarRule;
import com.noodleofdeath.pastaparser.model.graph.RootedTree;

/**
 * Specifications for a parser rule match (PRM) tree that extends
 * {@link RootedTree}.
 * 
 * @param <Grammar> type of grammar associated with this match tree.
 * @param <R> type of the parent, children, and root ancestor of this node.
 */
public interface SyntaxTree<R> extends RootedTree<SyntaxTree<R>> {
	
	/**
	 * Gets the grammar rule of this GRM tree.
	 * 
	 * @return grammar rule of this GRM tree.
	 */
	public abstract GrammarRule rule();

	/**
	 * Sets the grammar rule for this GRM tree.
	 * 
	 * @param rule to set for this GRM tree.
	 */
	public abstract void setRule(GrammarRule rule);

	/**
	 * 
	 * Returns <code>true</code> if and only if the matches flag of this GRM tree is set
	 * to <code>true</code> (implementing classes are responsible for meeting this
	 * requirement).
	 * 
	 * @return <code>true</code> if and only if the matches flag of this GRM tree is set
	 *         to <code>true</code>.
	 */
	public abstract boolean matches();
	
	/**
	 * 
	 * Returns <code>true</code> if and only if the matches flag of this GRM tree is set
	 * to <code>true</code> and <code>tokenCount() > 0</code> (implementing classes are responsible for meeting this
	 * requirement).
	 * 
	 * @return <code>true</code> if and only if the matches flag of this GRM tree is set
	 *         to <code>true</code>.
	 */
	public abstract boolean absoluteMatch();

	/** Sets the matches flag to true for this GRM tree. */
	public abstract void resolve();

	/** Sets the matches flag to false for this GRM tree. */
	public abstract void defer();

	/**
	 * @return
	 */
	public abstract List<R> tokens();

	/**
	 * @param token
	 * @return
	 */
	public abstract boolean addToken(R token);

	/**
	 * @param tokens
	 * @return
	 */
	public abstract boolean addTokens(List<R> tokens);

	/**
	 * 
	 */
	public abstract void clearTokens();

	/**
	 * @return
	 */
	public abstract int tokenCount();

}
