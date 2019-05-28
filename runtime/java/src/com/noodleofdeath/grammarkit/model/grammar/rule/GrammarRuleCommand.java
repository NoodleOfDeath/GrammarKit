package com.noodleofdeath.pastaparser.model.grammar.rule;

import java.util.List;

public interface GrammarRuleCommand {
	public abstract String getAction();

	public default boolean hasParameters() {
		return getParameters().size() > 0;
	}

	public abstract List<String> getParameters();

	public abstract String get(int paramInt);
}
