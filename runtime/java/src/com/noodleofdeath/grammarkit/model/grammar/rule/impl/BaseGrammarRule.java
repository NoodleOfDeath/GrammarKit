package com.noodleofdeath.pastaparser.model.grammar.rule.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;

import com.noodleofdeath.pastaparser.model.grammar.Grammar;
import com.noodleofdeath.pastaparser.model.grammar.rule.GrammarRuleComponentType;
import com.noodleofdeath.pastaparser.model.grammar.rule.GrammarRule;
import com.noodleofdeath.pastaparser.model.grammar.rule.GrammarRuleCommand;
import com.noodleofdeath.pastaparser.model.grammar.rule.GrammarRuleType;
import com.noodleofdeath.pastaparser.model.graph.impl.AbstractGrammarTree;

/**
 * Abstract implementation of {@link GrammarRule}.
 * 
 */
public class BaseGrammarRule extends AbstractGrammarTree<GrammarRule> implements GrammarRule {

	/** Children that are queued for adding. */
	protected List<GrammarRule> queue = new ArrayList<>();

	/** Parent grammar associated with this grammar rule. */
	protected Grammar grammar;

	/** Unique identifier for this grammar rule. */
	protected String id = null;

	/** Immediate atomic value of this grammar rule. */
	protected String value = null;

	/**
	 * 
	 */
	protected HashMap<GrammarRuleType, ArrayList<GrammarRule>> ruleMap = new LinkedHashMap<>();

	/**
	 * <code>true</code> if this rule is an exclusion rule; <code>false</code>,
	 * otherwise.
	 */
	protected boolean inverted = false;

	/** Order of this grammar rule. */
	protected int order = Integer.MAX_VALUE;

	/** Categories associated with this grammar rule. */
	protected List<String> categories = new ArrayList<>();

	/** Option flags of this grammar rule. */
	protected List<String> options = new ArrayList<>();

	/** Type of this grammar rule. Default is {@link GrammarRuleType#Unknown}. */
	protected GrammarRuleType ruleType = GrammarRuleType.Unknown;

	/**
	 * Type of this grammar rule. Default is {@link GrammarRuleComponentType#Unknown}.
	 */
	protected GrammarRuleComponentType componentType = GrammarRuleComponentType.Unknown;

	/** Command of this grammar rule, if one exists. */
	protected GrammarRuleCommand command = null;

	/** Root context of this grammar rule, if one exists. */
	protected GrammarRule rootContext = null;

	/** Previous sibling of this grammar rule, if one exists. */
	protected GrammarRule prev = null;

	/** Next sibling of this grammar rule, if one exists. */
	protected GrammarRule next = null;

	/** Constructs a new grammar rule with no initialized properties. */
	public BaseGrammarRule() {

	}

	/**
	 * Constructs a new grammar rule with an initial identifier.
	 * 
	 * @param id to set for this grammar rule.
	 */
	public BaseGrammarRule(String id) {
		this(id, null);
	}

	/**
	 * Constructs a new grammar rule with an initial identifier and value.
	 * 
	 * @param id    to set for this grammar rule.
	 * @param value to set for this grammar rule.
	 */
	public BaseGrammarRule(String id, String value) {
		this(id, value, GrammarRuleComponentType.Unknown);
	}

	/**
	 * Constructs a new grammar rule with an initial identifier, value, and rule
	 * type.
	 * 
	 * @param id    to set for this grammar rule.
	 * @param value to set for this grammar rule.
	 * @param type  to set for this grammar rule.
	 */
	public BaseGrammarRule(String id, String value, GrammarRuleComponentType componentType) {
		this(id, value, componentType, null);
	}

	/**
	 * Constructs a new grammar rule with an initial identifier, value, rule type,
	 * and grammar.
	 * 
	 * @param id            to set for this grammar rule.
	 * @param value         to set for this grammar rule.
	 * @param componentType to set for this grammar rule.
	 * @param grammar       to set for this grammar rule.
	 */
	public BaseGrammarRule(String id, String value, GrammarRuleComponentType componentType, Grammar grammar) {
		this.id = id;
		this.value = value;
		this.componentType = componentType;
		this.grammar = grammar;
	}

	@Override
	public String toString() {

		String stringValue = "";

		switch (componentType) {

		case Literal:
			stringValue += String.format("'%s'%s", value, quantifier());
			break;

		case Composite:
			break;

		case LexerRule:
		case LexerFragment:
		default:
			stringValue += String.format("%s%s", value, quantifier());
			break;

		}

		if (subrules().size() > 0) {
			List<String> strings = new ArrayList<>();
			for (GrammarRule subrule : subrules())
				strings.add(subrule.toString());
			stringValue += String.format(" (%s)%s", String.join(" | ", strings), quantifier());
		}

		if (next() != null)
			stringValue += String.format(" %s", next());
		if (command != null)
			stringValue += String.format(" -> %s", command);
		if (inverted())
			stringValue = String.format("~%s", stringValue);

		return stringValue.trim();

	}

	@Override
	public List<GrammarRule> subrules(GrammarRuleType ruleType) {
		return ruleMap.get(ruleType);
	}

	@Override
	public HashMap<GrammarRuleType, ArrayList<GrammarRule>> ruleMap() {
		return ruleMap;
	}

	@Override
	public boolean enqueue(GrammarRule rule) {
		return queue.add(rule);
	}

	@Override
	public List<GrammarRule> queue() {
		return queue;
	}

	@Override
	public void clearQueue() {
		queue.clear();
	}

	@Override
	public Grammar grammar() {
		return grammar;
	}

	@Override
	public void setGrammar(Grammar grammar) {
		this.grammar = grammar;
	}

	@Override
	public String id() {
		return id;
	}

	@Override
	public void setId(String id) {
		this.id = id;
	}

	@Override
	public String value() {
		return value;
	}

	@Override
	public void setValue(String value) {
		this.value = value;
	}

	@Override
	public boolean inverted() {
		return inverted;
	}

	@Override
	public void setInverted(boolean inverted) {
		this.inverted = inverted;
	}

	@Override
	public int order() {
		return order;
	}

	@Override
	public void setOrder(int order) {
		this.order = order;
	}

	@Override
	public GrammarRuleType ruleType() {
		return ruleType;
	}

	@Override
	public void setRuleType(GrammarRuleType ruleType) {
		this.ruleType = ruleType;
	}

	@Override
	public GrammarRuleComponentType componentType() {
		return componentType;
	}

	@Override
	public void setRuleComponentType(GrammarRuleComponentType componentType) {
		this.componentType = componentType;
	}

	@Override
	public List<String> categories() {
		return categories;
	}

	@Override
	public void setCategories(List<String> categories) {
		this.categories = categories;
	}

	@Override
	public List<String> options() {
		return options;
	}

	@Override
	public void setOptions(List<String> options) {
		this.options = options;
	}

	@Override
	public GrammarRuleCommand command() {
		return command;
	}

	@Override
	public void setCommand(GrammarRuleCommand command) {
		this.command = command;
	}

	@Override
	public GrammarRule prev() {
		return prev;
	}

	@Override
	public void setPrev(GrammarRule prev) {
		this.prev = prev;
	}

	@Override
	public GrammarRule next() {
		return next;
	}

	@Override
	public void setNext(GrammarRule next) {
		next.setPrev(this);
		this.next = next;
	}

}
