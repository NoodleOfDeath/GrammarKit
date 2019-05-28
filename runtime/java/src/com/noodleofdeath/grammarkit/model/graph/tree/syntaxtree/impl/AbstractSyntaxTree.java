package com.noodleofdeath.pastaparser.model.graph.tree.syntaxtree.impl;

import java.util.ArrayList;
import java.util.List;

import com.noodleofdeath.pastaparser.model.grammar.Grammar;
import com.noodleofdeath.pastaparser.model.grammar.rule.GrammarRule;
import com.noodleofdeath.pastaparser.model.graph.impl.AbstractRootedTree;
import com.noodleofdeath.pastaparser.model.graph.tree.syntaxtree.SyntaxTree;

/**
 * Base implementation of {@link SyntaxTree} that extends
 * {@link AbstractRootedTree}.
 * 
 * @param <Grammar> type of grammar associated withi this match tree.
 * @param <R> type used by tokens found in this GRM tree.
 * @param <T> type of tokens used in this GRM tree.
 */
public abstract class AbstractSyntaxTree<R>
		extends AbstractRootedTree<SyntaxTree<R>> implements SyntaxTree<R> {

	/** grammar rule for this GRM tree, if one exists. */
	protected GrammarRule rule = null;

	/** Matches flag of this GRM tree. */
	protected boolean matches = false;

	/**
	 * 
	 */
	protected List<R> tokens = new ArrayList<>();

	/** Constructs a new GRM tree with no initial properties. */
	public AbstractSyntaxTree() {

	}

	/**
	 * Constructs a new GRM tree with an initial parser rule.
	 * 
	 * @param rule to set for this GRM tree.
	 */
	public AbstractSyntaxTree(GrammarRule rule) {
		this.rule = rule;
	}

	@Override
	public GrammarRule rule() {
		return rule;
	}

	@Override
	public void setRule(GrammarRule rule) {
		this.rule = rule;
	}

	@Override
	public void resolve() {
		matches = true;
	}

	@Override
	public void defer() {
		matches = false;
	}

	@Override
	public String toString() {
		return String.format("%s: %s {%d}", rule != null ? rule.id() : "No Match", tokens, tokenCount());
	}

	@Override
	public boolean matches() {
		return matches;
	}

	@Override
	public boolean absoluteMatch() {
		return matches && tokenCount() > 0;
	}

	@Override
	public List<R> tokens() {
		return tokens;
	}

	@Override
	public boolean addToken(R token) {
		return tokens.add(token);
	}

	@Override
	public boolean addTokens(List<R> tokens) {
		boolean success = true;
		for (R token : tokens)
			if (!addToken(token))
				success = false;
		return success;
	}

	@Override
	public void clearTokens() {
		tokens.clear();
	}

	@Override
	public int tokenCount() {
		return tokens.size();
	}

}
