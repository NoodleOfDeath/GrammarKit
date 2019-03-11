package com.noodleofdeath.pastaparser.model.grammar.loader;

import com.noodleofdeath.pastaparser.model.grammar.Grammar;

public interface GrammarLoader {
	
	public static String UnmatchedRuleId = "UNMATCHED";
	
	public static String UnmatchedRuleDefinition = "'.'";

	/**
	 * Static string key XML tags used when accessing XML elements in the grammar
	 * configuration file.
	 */
	public static abstract interface XMLTag {

		/** Definition grammar XML tag. */
		public static final String Definition = "definition";

		/** Root grammar XML tag. */
		public static final String Grammar = "grammar";

		/** Rule grammar XML tag. */
		public static final String Rules = "rules";

		/** Rule grammar XML tag. */
		public static final String Rule = "rule";

		/** Word grammar XML tag. */
		public static final String Word = "word";

	}

	/**
	 * Static string key XML tags used when accessing XML elements in the grammar
	 * configuration file.
	 */
	public static abstract interface XMLAttribute {

		/** Extends grammar XML attribute. */
		public static final String Extends = "extends";

		/** Category grammar XML attribute. */
		public static final String Category = "category";

		/** Id grammar XML attribute. */
		public static final String Id = "id";

		/** Options grammar XML attribute. */
		public static final String Omit = "omit";

		/** Options grammar XML attribute. */
		public static final String Options = "options";

		/** Order grammar XML attribute. */
		public static final String Order = "order";

	}

	/**
	 * 
	 */
	public static String PACKAGE_EXTENSION = "grammar";

	/**
	 * 
	 */
	public static String PACKAGE_CONFIG_FILE = "grammar.xml";

	public abstract String[] searchPaths();
	
	public abstract Grammar load(String prefix);
	
}
