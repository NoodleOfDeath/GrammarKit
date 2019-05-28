package com.noodleofdeath.pastaparser.model.grammar.rule;

public enum GrammarRuleComponentType {

	/** Unknown Component type. Default value. */
	Unknown,

	/** Atom Component type. */
	Atom,

	/** Composite group Component type. */
	Composite,

	/** Regular expression Component type. */
	Expression,

	/** Literal string Component type. */
	Literal,

	/** Lexer Component type. */
	LexerRule,

	/** Lexer fragment Component type. */
	LexerFragment,

	/** Parser Component type. */
	ParserRule;

	/**
	 * Returns the Component type associated with a specified ordinal, or {@link #Once}
	 * if no such Component type exists for that specified ordinal.
	 * 
	 * @param ordinal of the Component type in {@link values()}.
	 * @return the Component type associated with the specified ordinal, or {@link #Once}
	 *         if no such Component type exists for that specified ordinal.
	 */
	public static GrammarRuleComponentType from(int ordinal) {
		for (GrammarRuleComponentType RuleComponentType : values())
			if (RuleComponentType.ordinal() == ordinal)
				return RuleComponentType;
		return Unknown;
	}

	/**
	 * Returns <code>true</code> if this Component type is contained in the specified array of
	 * types; <code>false</code>, otherwise.
	 * 
	 * @param types to compare this Component type against.
	 * @return <code>true</code> if this Component type is contained in the specified array of
	 *         types; <code>false</code>, otherwise.
	 */
	public boolean equals(GrammarRuleComponentType... types) {
		for (GrammarRuleComponentType type : types)
			if (equals(type))
				return true;
		return false;
	}
	
}
