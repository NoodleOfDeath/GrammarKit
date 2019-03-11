package com.noodleofdeath.pastaparser;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

/** Enumerated type for an atomic quantifier. */
public class Quantifier {

	/** Quantifier for a greedy wildcard match or optional match. */
	public static Quantifier NoneOrMore = new Quantifier("*", true, true, false);

	/** Quantifier for a lazy greedy match or optional match. */
	public static Quantifier NoneOrMoreLazy = new Quantifier("*?", true, true, true);

	/** Quantifier for exactly one match. */
	public static Quantifier Once = new Quantifier("", false, false, false);

	/** Quantifier for at least one match with a greedy wildcard match. */
	public static Quantifier OnceOrMore = new Quantifier("+", false, true, false);

	/** Quantifier for at least one match with a lazy greedy wildcard match. */
	public static Quantifier OnceOrMoreLazy = new Quantifier("+?", false, true, true);

	/** Quantifier for an optional match. */
	public static Quantifier Optional = new Quantifier("?", true, false, false);

	/** Quantifier for a lazy optional match. */
	public static Quantifier OptionalLazy = new Quantifier("??", true, false, true);
	
	/** Possible values */
	public static Quantifier[] values() {
		return new Quantifier[] {
		   NoneOrMore,
		   NoneOrMoreLazy,
		   Once,
		   OnceOrMore,
		   OnceOrMoreLazy,
		   Optional,
		   OptionalLazy,
		};
	}

	/** String representation of this quantifier. */
	private String value;

	/**
	 * <code>true</code> if this quantifier is an optional match;
	 * <code>false</code>, otherwise.
	 */
	private boolean optional = false;

	/**
	 * <code>true</code> if this quantifier is a greedy match; <code>false</code>,
	 * otherwise.
	 */
	private boolean greedy = false;

	/**
	 * <code>true</code> if this quantifier is a lazy match; <code>false</code>,
	 * otherwise.
	 */
	private boolean lazy = false;
	
	private int min = -1;
	
	private int max = -1;
	
	public Quantifier(String value, boolean optional, boolean greedy, boolean lazy) {
		this(value, optional, greedy, lazy, -1, -1);
	}

	/**
	 * Constructs a new quantifier with an initial value, optional flag, greedy
	 * flag, and lazy flag.
	 *
	 * @param value    String representation of this quantifier.
	 * @param optional <code>true</code> if this quantifier is an optional match;
	 *                 <code>false</code>, otherwise.
	 * @param greedy   <code>true</code> if this quantifier is an greedy match;
	 *                 <code>false</code>, otherwise.
	 * @param lazy     <code>true</code> if this quantifier is a lazy match;
	 *                 <code>false</code>, otherwise.
	 */
	public Quantifier(String value, boolean optional, boolean greedy, boolean lazy, int min, int max) {
		this.value = value;
		this.optional = optional;
		this.greedy = greedy;
		this.lazy = lazy;
	}

	/**
	 * Returns the quantifier associated with a specified ordinal, or {@link #Once}
	 * if no such quantifier exists for that specified ordinal.
	 * 
	 * @param ordinal of the quantifier in {@link values()}.
	 * @return the quantifier associated with the specified ordinal, or
	 *         {@link #Once} if no such quantifier exists for that specified
	 *         ordinal.
	 */
	public static Quantifier from(int ordinal) {
		return values()[ordinal];
	}

	/**
	 * Returns the quantifier associated with a specified value, or {@link #Once} if
	 * no such quantifier exists with the specified value.
	 * 
	 * @param value of the quantifier.
	 * @return the quantifier associated with the specified value, or {@link #Once}
	 *         if no such quantifier exists with the specified value.
	 */
	public static Quantifier from(String value) {
		if (value.indexOf("{") > 0) {
			Matcher matcher = Pattern.compile("\\{\\s*(\\d)?(?:\\s*(,)\\s*(\\d)?)?\\s*\\}(\\?)?").matcher(value);
			if (matcher.find()) {
				int min = matcher.group(1).isEmpty() ? 0 : Integer.parseInt(matcher.group(1));
				int max = matcher.group(2).isEmpty() ? min
						: (matcher.group(3).isEmpty() ? 9 : Integer.parseInt(matcher.group(3)));
				boolean lazy = !matcher.group(4).isEmpty();
				return new Quantifier(value, min == 0, min < max, lazy, min, max);
			}
			return Once;
		}
		for (Quantifier quantifier : values())
			if (value.equals(quantifier.value))
				return quantifier;
		return Once;
	}

	@Override
	public String toString() {
		return String.format("%s", value);
	}

	/**
	 * Returns <code>true</code> if this quantifier is contained in the specified
	 * array of quantifiers; <code>false</code>, otherwise.
	 * 
	 * @param quantifiers to compare this quantifier against.
	 * @return <code>true</code> if this quantifier is contained in the specified
	 *         array of quantifiers; <code>false</code>, otherwise.
	 */
	public boolean equals(Quantifier... quantifiers) {
		for (Quantifier quantifier : quantifiers)
			if (equals(quantifier))
				return true;
		return false;
	}

	/**
	 * <code>true</code> if this quantifier is an optional match;
	 * <code>false</code>, otherwise.
	 * 
	 * @return <code>true</code> if this quantifier is an optional match;
	 *         <code>false</code>, otherwise.
	 */
	public boolean optional() {
		return optional;
	}

	/**
	 * <code>true</code> if this quantifier is a greedy match; <code>false</code>,
	 * otherwise.
	 * 
	 * @return<code>true</code> if this quantifier is a greedy match;
	 *                          <code>false</code>, otherwise.
	 */
	public boolean greedy() {
		return greedy;
	}

	/**
	 * <code>true</code> if this quantifier is a lazy match; <code>false</code>,
	 * otherwise.
	 * 
	 * @return<code>true</code> if this quantifier is a lazy match;
	 *                          <code>false</code>, otherwise.
	 */
	public boolean lazy() {
		return lazy;
	}

	public int min() {
		return min;
	}

	public void setMin(int min) {
		this.min = min;
	}

	public int max() {
		return max;
	}

	public void setMax(int max) {
		this.max = max;
	}
	
	public boolean hasRange() {
		return min > -1 && max > -1;
	}
	
	public boolean meets(int matchCount) {
		return matchCount >= min && matchCount <= max;
	}

}
