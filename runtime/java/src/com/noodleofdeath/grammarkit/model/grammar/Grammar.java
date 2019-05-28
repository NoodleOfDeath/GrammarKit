package com.noodleofdeath.pastaparser.model.grammar;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import com.noodleofdeath.pastaparser.model.grammar.rule.GrammarRule;
import com.noodleofdeath.pastaparser.model.grammar.rule.GrammarRuleType;
import com.noodleofdeath.pastaparser.model.grammar.rule.impl.BaseGrammarRule;

/** Specifications for a grammar. */
public interface Grammar {

	/**
	 * 
	 * @return
	 */
	public abstract GrammarRule rootRule();

	/**
	 * 
	 * @param rootRule
	 */
	public abstract void setRootRule(GrammarRule rootRule);

	/**
	 * 
	 * @return
	 */
	public abstract List<GrammarRule> rules();

	/**
	 * 
	 * @return
	 */
	public default List<GrammarRule> rules(GrammarRuleType ruleType) {
		return rootRule().subrules(ruleType);
	}

	/**
	 * 
	 * @param rules
	 */
	public abstract void setRules(List<GrammarRule> rules);

	/**
	 * 
	 * @return
	 */
	public abstract HashMap<String, GrammarRule> ruleMap();

	/**
	 * 
	 * @return
	 */
	public abstract void setRuleMap(HashMap<String, GrammarRule> ruleMap);

	/**
	 * @param key
	 * @return
	 */
	public default GrammarRule rule(String key) {
		GrammarRule rule = ruleMap().get(key);
		if (rule == null) {
			System.out.println(String.format("Cannot find rule: %s", key));
			return new BaseGrammarRule(key);
		}
		return rule;
	}

	/**
	 * 
	 * @return
	 */
	public abstract Grammar parentGrammar();

	/**
	 * Prints all rules of this grammar to the standard output.
	 */
	public default void printRules() {
		printRules(rules());
	}

	/**
	 * Prints all rules of this grammar to the standard output.
	 */
	public default void printRules(GrammarRuleType ruleType) {
		printRules(rules(ruleType));
	}

	/**
	 * Prints all rules of this grammar to the standard output.
	 */
	public abstract void printRules(List<GrammarRule> rules);

	/**
	 * 
	 */
	public abstract void sortRules();

	/**
	 * 
	 * @return
	 */
	public abstract GrammarRule unmatchedRule();

	/**
	 * 
	 * @param unmatchedRule
	 */
	public abstract void setUnmatchedRule(GrammarRule unmatchedRule);

}
