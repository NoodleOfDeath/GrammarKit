package com.noodleofdeath.pastaparser.model.grammar;

import com.noodleofdeath.pastaparser.model.grammar.rule.GrammarRule;
import com.noodleofdeath.pastaparser.model.grammar.rule.GrammarRuleComponentType;

/**
 * Specifications for a grammar rule generator. This service is often tightly
 * coupled with {@link Grammar} implementations that use custom implementations
 * of {@link GrammarRule}.
 * 
 * @param <Grammar> type of grammar this generator is associated with.
 */
public interface GrammarRuleGenerator {

	/**
	 * @param id
	 * @return
	 */
	public default GrammarRule generateRule(String id) {
		return generateRule(id, "");
	}

	/**
	 * 
	 * @param id
	 * @param ruleDefinition
	 * @return
	 */
	public default GrammarRule generateRule(String id, String ruleDefinition) {
		return generateRule(id, ruleDefinition, GrammarRuleComponentType.Atom);
	}

	/**
	 * @param id
	 * @param ruleDefinition
	 * @param grammar
	 * @return
	 */
	public default GrammarRule generateRule(String id, String ruleDefinition, Grammar grammar) {
		return generateRule(id, ruleDefinition, GrammarRuleComponentType.Atom, grammar);
	}

	/**
	 * @param id
	 * @param ruleDefinition
	 * @param type
	 * @return
	 */
	public default GrammarRule generateRule(String id, String ruleDefinition, GrammarRuleComponentType type) {
		return generateRule(id, ruleDefinition, GrammarRuleComponentType.Atom, null);
	}

	/**
	 * @param id
	 * @param ruleDefinition
	 * @param type
	 * @param grammar
	 * @return
	 */
	public abstract GrammarRule generateRule(String id, String ruleDefinition, GrammarRuleComponentType type, Grammar grammar);

}
