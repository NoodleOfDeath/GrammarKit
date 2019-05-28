package com.noodleofdeath.pastaparser.model.grammar.rule.impl;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.regex.Matcher;

import com.noodleofdeath.pastaparser.model.grammar.pattern.GrammarPattern;
import com.noodleofdeath.pastaparser.model.grammar.rule.GrammarRuleCommand;

public class BaseGrammarRuleCommand implements GrammarRuleCommand {

	protected String action;
	protected List<String> parameters = new ArrayList<>();

	public BaseGrammarRuleCommand(String command) {
		Matcher commandMatcher = GrammarPattern.CGCommand.matcher(command);
		if (commandMatcher.matches()) {
			action = commandMatcher.group(1).trim();
			if (commandMatcher.group(2) != null) {
				parameters = Arrays.asList(commandMatcher.group(2).trim().split("\\s*,\\s*"));
			}
		}
	}

	public BaseGrammarRuleCommand(String action, List<String> parameters) {
		this.action = action;
		this.parameters = parameters;
	}

	@Override
	public String toString() {
		if (parameters.size() == 0) {
			return String.format("%s", new Object[] { action });
		}
		return String.format("%s(%s)", new Object[] { action, String.join(", ", parameters) });
	}

	@Override
	public String getAction() {
		return action;
	}

	@Override
	public List<String> getParameters() {
		return parameters;
	}

	@Override
	public String get(int index) {
		return parameters.get(index);
	}

}
