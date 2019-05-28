package com.noodleofdeath.pastaparser.model.grammar.rule;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;

import com.noodleofdeath.pastaparser.model.grammar.Grammar;
import com.noodleofdeath.pastaparser.model.graph.GrammarTree;

/**
 * Specifications for a grammar rule.
 * 
 * @param the type of the parent grammar associated with this grammar rule.
 */
public interface GrammarRule extends GrammarTree<GrammarRule>, ChildQueue {

	/**   */
	public default void consumeQueue() {
		for (GrammarRule rule : queue())
			addChild(rule);
		clearQueue();
	}

	/**
	 * Gets the parent grammar associated with this grammar rule.
	 * 
	 * @return parent grammar associated with this grammar rule.
	 */
	public abstract Grammar grammar();

	/**
	 * Sets the parent grammar associated with this grammar rule.
	 * 
	 * @param grammar to set for this grammar rule.
	 */
	public abstract void setGrammar(Grammar grammar);

	/**
	 * <code>true</code> if the {@link type()} of this grammar rule is not
	 * {@link GrammarRuleType.Unknown}; <code>false</code>, otherwise.
	 * 
	 * @return <code>true</code> if the {@link type()} of this grammar rule is not
	 *         {@link GrammarRuleType.Unknown}; <code>false</code>, otherwise.
	 */
	public default boolean exists() {
		return componentType() != GrammarRuleComponentType.Unknown;
	}
	
	public List<GrammarRule> subrules(GrammarRuleType ruleType);
	
	public HashMap<GrammarRuleType, ArrayList<GrammarRule>> ruleMap();

	/**
	 * Gets the unique identifier of this grammar rule.
	 * 
	 * @return unique identifier of this grammar rule.
	 */
	public abstract String id();

	/**
	 * Sets the unique identifier of this grammar rule.
	 * 
	 * @param id to set for this grammar rule.
	 */
	public abstract void setId(String id);

	/**
	 * Gets the value of this grammar rule.
	 * 
	 * This value only consists of its immediate atomic value and not the extended
	 * value of its children. To get that value either implement
	 * {@link Object#toString()} or call {@link Lexer#getExpression(GrammarRule)}.
	 * 
	 * @see Lexer#getExpression(GrammarRule)
	 * 
	 * @return value of this grammar rule.
	 */
	public abstract String value();

	/**
	 * Sets the immediate atomic value of this grammar rule.
	 * 
	 * @param value to set as the immediate atomic value of this grammar rule.
	 */
	public abstract void setValue(String value);

	/**
	 * <code>true</code> if this rule is an exclusion rule; <code>false</code>,
	 * otherwise.
	 * 
	 * @return <code>true</code> if this rule is an exclusion rule;
	 *         <code>false</code>, otherwise.
	 */
	public abstract boolean inverted();

	/**
	 * <code>true</code> if this rule is an exclusion rule; <code>false</code>,
	 * otherwise.
	 * 
	 * @param inverted <code>true</code> if this rule is an exclusion rule;
	 *                 <code>false</code>, otherwise.
	 */
	public abstract void setInverted(boolean inverted);

	/** @return */
	public abstract int order();

	/**
	 * @param order
	 */
	public abstract void setOrder(int order);

	/** @return */
	public abstract GrammarRuleType ruleType();

	/**
	 * @param ruleType
	 */
	public abstract void setRuleType(GrammarRuleType ruleType);

	/** @return */
	public abstract GrammarRuleComponentType componentType();

	/**
	 * @param componentType
	 */
	public abstract void setRuleComponentType(GrammarRuleComponentType componentType);

	/** @return */
	public abstract List<String> categories();

	/**
	 * @param category
	 */
	public abstract void setCategories(List<String> category);

	/** @return */
	public abstract List<String> options();

	/**
	 * @param options
	 */
	public abstract void setOptions(List<String> options);

	/**
	 * @return
	 */
	public default boolean skip() {
		return options().contains("skip");
	}

	/**
	 * @return
	 */
	public default boolean omit() {
		return options().contains("omit");
	}

	/** @return */
	public abstract GrammarRuleCommand command();

	/**
	 * @param command
	 */
	public abstract void setCommand(GrammarRuleCommand command);

	/**
	 * Gets the subrules of this grammar rule. Alias for
	 * {@link GrammarRule#children()}.
	 * 
	 * @return the subrules of this grammar rule.
	 */
	public default List<GrammarRule> subrules() {
		return children();
	}

	/**
	 * Sets the subrules of this grammar rule. Alias for
	 * {@link GrammarRule#setSubrules(List)}.
	 * 
	 * @param rules to set for this grammar rule.
	 */
	public default void setSubrules(List<GrammarRule> rules) {
		setChildren(rules);
	}

	/**
	 * @return <code>true</code> if this rule calls itself in one of its subrules.
	 */
	public default boolean recursive() {
		return recursive(this);
	}

	/**
	 * 
	 * @param ref
	 * @return <code>true</code> if this rule calls itself in one of its subrules.
	 */
	public default boolean recursive(GrammarRule ref) {
		for (GrammarRule subrule : subrules()) {
			if ((subrule.ruleType().equals(GrammarRuleType.LexerRule, GrammarRuleType.LexerFragment,
					GrammarRuleType.ParserRule) && subrule.value().equals(ref.id())) || subrule.recursive(ref)) {
				return true;
			}
		}
		return false;
	}

	/**
	 * @return
	 */
	public default boolean recursiveFatal() {
		return recursiveFatal(this);
	}

	/**
	 * @param ref
	 * @return
	 */
	public default boolean recursiveFatal(GrammarRule ref) {
		List<Boolean> fatal = new ArrayList<>();
		for (GrammarRule subrule : subrules())
			fatal.add((subrule.ruleType().equals(GrammarRuleType.LexerRule, GrammarRuleType.LexerFragment,
					GrammarRuleType.ParserRule) && subrule.value().equals(ref.id())));
		return !(fatal.size() > 0 && fatal.contains(false));
	}

	/**
	 * Sorts the subrules of this grammar rule using a specified comparator.
	 * 
	 * @param comparator to sort the subrules of this grammar rule with.
	 * @return the subrules of this grammar rule after they have been sorted.
	 */
	public default List<GrammarRule> sortSubrules(Comparator<GrammarRule> comparator) {
		List<GrammarRule> subrules = children();
		subrules.sort(comparator);
		for (GrammarRule subrule : subrules) {
			ArrayList<GrammarRule> rules = ruleMap().get(subrule.ruleType()) != null
					? new ArrayList<>(ruleMap().get(subrule.ruleType()))
					: new ArrayList<>();
			rules.add(subrule);
			ruleMap().put(subrule.ruleType(), rules);
		}
		for (ArrayList<GrammarRule> list : ruleMap().values())
			list.sort(comparator);
		return subrules;
	}

	/**
	 * Gets the previous sibling of this grammar rule, if one exists.
	 * 
	 * @return the previous sibling of this grammar rule, if one exists.
	 */
	public abstract GrammarRule prev();

	/**
	 * Sets the previous sibling of this grammar rule.
	 * 
	 * @param prevRule to set as the previous sibling of this grammar rule.
	 */
	public abstract void setPrev(GrammarRule prevRule);

	/**
	 * Gets the next sibling of this grammar rule, if one exists.
	 * 
	 * @return the next sibling of this grammar rule, if one exists.
	 */
	public abstract GrammarRule next();

	/**
	 * Sets the next sibling of this grammar rule.
	 * 
	 * @param nextRule to set as the next sibling of this grammar rule.
	 */
	public abstract void setNext(GrammarRule nextRule);

	/**
	 * Computes and returns the longest path that branches from each child of this
	 * grammar rule recursively until a leaf node is encountered.
	 * 
	 * @return the longest path that branches from each child of this grammar rule
	 *         recursively until a leaf node is encountered.
	 */
	public default int length() {
		int length = 0;
		if (!quantifier().optional()) {
			for (GrammarRule subrule : subrules()) {
				if (length < subrule.length())
					length = subrule.length();
			}
			--length;
		}
		return length + (next() != null ? next().length() : 0) + (quantifier().optional() ? 0 : 1);
	}

}
