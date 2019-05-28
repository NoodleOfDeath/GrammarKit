package com.noodleofdeath.pastaparser.model.grammar.rule;

/** Enumerated type for a grammar rule type. */
public enum GrammarRuleType {

	/** Unknown rule type. Default value. */
	Unknown,

	/** Lexer rule type. */
	LexerRule,

	/** Lexer fragment rule type. */
	LexerFragment,

	/** Parser rule type. */
	ParserRule;

	/**
	 * Returns the rule type associated with a specified ordinal, or {@link #Once}
	 * if no such rule type exists for that specified ordinal.
	 * 
	 * @param ordinal of the rule type in {@link values()}.
	 * @return the rule type associated with the specified ordinal, or {@link #Once}
	 *         if no such rule type exists for that specified ordinal.
	 */
	public static GrammarRuleType from(int ordinal) {
		for (GrammarRuleType ruleType : values())
			if (ruleType.ordinal() == ordinal)
				return ruleType;
		return Unknown;
	}

	/**
	 * Returns <code>true</code> if this rule type is contained in the specified array of
	 * types; <code>false</code>, otherwise.
	 * 
	 * @param types to compare this rule type against.
	 * @return <code>true</code> if this rule type is contained in the specified array of
	 *         types; <code>false</code>, otherwise.
	 */
	public boolean equals(GrammarRuleType... types) {
		for (GrammarRuleType type : types)
			if (equals(type))
				return true;
		return false;
	}

}
