package com.noodleofdeath.pastaparser.model.grammar.impl;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;

import com.noodleofdeath.pastaparser.model.grammar.Grammar;
import com.noodleofdeath.pastaparser.model.grammar.GrammarRuleGenerator;
import com.noodleofdeath.pastaparser.model.grammar.rule.GrammarRule;
import com.noodleofdeath.pastaparser.model.grammar.rule.impl.BaseGrammarRule;

/**
 * Abstract implementation of a {@link Grammar} and {@link GrammarRuleGenerator}
 * 
 */
public class BaseGrammar implements Grammar {

	/** Parent grammar of this grammar, if one exists. */
	public Grammar parentGrammar;
	
	/** Root lexer rule of this grammar. */
	protected GrammarRule rootRule = new BaseGrammarRule();
	
	/** Rule map of this grammar. */
	protected HashMap<String, GrammarRule> ruleMap = new LinkedHashMap<>();
	
	/**
	 * 
	 */
	protected GrammarRule unmatchedRule;

	/** Constructs a new grammar with no root element. */
	public BaseGrammar() {

	}

	/**
	 * Constructs a new grammar from a specified filename.
	 * 
	 * @param filename of the grammar bundle to load this compound grammar from.
	 * @throws Exception if an error is encountered while constructing this grammar.
	 */
	public BaseGrammar(GrammarRule rootRule, HashMap<String, GrammarRule> ruleMap) throws Exception {
		this.rootRule = rootRule;
		this.ruleMap = ruleMap;
	}

	@Override
	public GrammarRule rootRule() {
		return rootRule;
	}

	@Override
	public void setRootRule(GrammarRule rootRule) {
		this.rootRule = rootRule;
	}

	/**
	 * @return
	 */
	@Override
	public List<GrammarRule> rules() {
		return rootRule.subrules();
	}
	
	/**
	 * 
	 * @param rules
	 */
	@Override
	public void setRules(List<GrammarRule> rules) {
		rootRule.setSubrules(rules);
	}

	/**
	 * @return
	 */
	@Override
	public HashMap<String, GrammarRule> ruleMap() {
		return ruleMap;
	}
	
	/**
	 * 
	 * @param rules
	 */
	@Override
	public void setRuleMap(HashMap<String, GrammarRule> ruleMap) {
		this.ruleMap = ruleMap;
	}

	@Override
	public Grammar parentGrammar() {
		return parentGrammar;
	}

	@Override
	public void printRules(List<GrammarRule> rules) {
		for (GrammarRule rule : rules)
			System.out.println(String.format("%s [%d]: %s", rule.id(), rule.order(), rule));
	}

	/**
	 * 
	 */
	public void sortRules() {
		rootRule.sortSubrules(new Comparator<GrammarRule>() {
			@Override
			public int compare(GrammarRule lhs, GrammarRule rhs) {
				int lhsOrder = lhs.order();
				int rhsOrder = rhs.order();
				return lhsOrder > rhsOrder ? 1 : lhsOrder < rhsOrder ? -1 : 0;
			}
		});
	}

	@Override
	public GrammarRule unmatchedRule() {
		return unmatchedRule;
	}

	@Override
	public void setUnmatchedRule(GrammarRule unmatchedRule) {
		this.unmatchedRule = unmatchedRule;
	}
	
}
