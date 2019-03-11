package com.noodleofdeath.pastaparser.model.grammar.pattern;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**  */
public enum GrammarPattern {

	/**   */
	Empty("(?:\\s*;\\s*)"),

	/**   */
	Literal("(?<!\\\\)'(?:\\\\'|[^'])*'(?:\\s*(?:\\.\\.)(?<!\\\\)'(?:\\\\'|[^'])*')?"),

	/**   */
	Expression("(?:\\s*\\^?(?:\\[.*?\\]|\\(\\?\\!.*\\)|\\.)\\$?)"),

	/**   */
	Word("(?:[_$\\p{L}]+)"),

	/**   */
	Group("(?:\\(.*)"),

	/**   */
	Atom("(?:" + Empty + "|" + Literal + "|" + Expression + "|" + Word + "|" + Group + ")"),

	/**   */
	Quantifier("(?:(?:[\\*\\+\\?]|\\{\\s*\\d?(?:\\s*,\\s*\\d?)?\\s*\\})\\??)"),

	/**   */
	CGFragment("(?:fragment\\s+(\\w+))"),

	/**   */
	CGDefinition("(.*?)(?:\\s*->\\s*([^']*))?(?:\\s*\\{(.*?)\\})?$"),

	/**   */
	CGCommand("(\\w+)\\s*(?:\\((.*?)\\))?"),

	/**   */
	CGParserAction("(\\w+)\\s*(?:\\((.*?)\\))?"),

	/**   */
	CGAlt("((?:(~)?" + Atom + "\\s*" + Quantifier + "?\\s*){1,})"),

	/**   */
	CGGroup("\\s*(\\(.*)\\s*"),

	/**   */
	CGGreedyGroup("\\((.*)\\)"),

	/**   */
	CGLiteral("(?<!\\\\)'((?:\\\\'|[^'])*)'(?:\\s*(?:\\.\\.)(?<!\\\\)'((?:\\\\'|[^'])*)')?"),

	/**   */
	CGExpression("(?:\\s*(" + Expression + "))"),

	/**   */
	CGAtom("(~)?\\s*(" + Atom + ")\\s*(" + Quantifier + "?)"),

	;

	public static class Flag {

		public static final int None = 0;
		public static final int StartAnchor = 1 << 0;
		public static final int EndAnchor = 1 << 1;
		public static final int IgnoreWhitespaces = 1 << 2;

	}

	/**   */
	private String pattern = "";

	/** @param pattern */
	private GrammarPattern(String pattern) {
		this.pattern = pattern;
	}

	@Override
	public String toString() {
		return pattern;
	}

	/**
	 * @param haystack
	 * @return
	 */
	public Matcher matcher(String haystack) {
		return matcher(haystack, 0);
	}

	/**
	 * @param haystack
	 * @return
	 */
	public Matcher matcher(String haystack, int flags) {
		String pattern = this.pattern;
		if ((flags & Flag.StartAnchor) != 0)
			pattern = String.format(((flags & Flag.IgnoreWhitespaces) != 0) ? "^\\s*%s" : "^%s", pattern);
		if ((flags & Flag.EndAnchor) != 0)
			pattern = String.format(((flags & Flag.IgnoreWhitespaces) != 0) ? "%s\\s*$" : "%s$", pattern);
		return Pattern.compile(pattern).matcher(haystack);
	}

}
