package com.noodleofdeath.pastaparser.io.token;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import com.noodleofdeath.pastaparser.io.TextRange;

/**   */
public interface TextToken extends Token<String>, TextRange {

	/**
	 * 
	 */
	static int StringOptionNone = 0;

	/**
	 * 
	 */
	static int StringOptionEscaped = 1 << 0;

	/**
	 * 
	 */
	static int StringOptionStripOuterBraces = 1 << 1;

	/**
	 * 
	 */
	static int StringOptionStripOuterBrackets = 1 << 2;

	/**
	 * 
	 */
	static int StringOptionStripOuterParentheses = 1 << 3;

	/**
	 * 
	 */
	static int StringOptionTruncate = 1 << 4;

	/**
	 * @param options
	 * @return
	 */
	public default String text(int options) {
		return text(options, 80);
	}

	/**
	 * @param options
	 * @param maxlength
	 * @return
	 */
	public default String text(int options, int maxlength) {

		String value = value();

		if ((options & StringOptionStripOuterBraces) != 0) {
			Matcher matcher = (Pattern.compile("^\\{((?s:.*))\\}$")).matcher(value);
			if (matcher.find())
				value = matcher.group(1);
		} else if ((options & StringOptionStripOuterBrackets) != 0) {
			Matcher matcher = (Pattern.compile("^\\[((?s:.*))\\]$")).matcher(value);
			if (matcher.find())
				value = matcher.group(1);
		} else if ((options & StringOptionStripOuterParentheses) != 0) {
			Matcher matcher = (Pattern.compile("^\\(((?s:.*))\\)$")).matcher(value);
			if (matcher.find())
				value = matcher.group(1);
		}

		if ((options & StringOptionEscaped) != 0) {
			value = value.replaceAll("\n", "\\\\n").replaceAll("\r", "\\\\r").replaceAll(" ", "\\\\s").replaceAll("\t",
					"\\\\t");
		}
		if ((options & StringOptionTruncate) != 0) {
			if (value.length() > maxlength) {
				String part = value.substring(0, Math.min(value.length() / 3, (maxlength - 3) / 3));
				String part2 = value.substring(value.length() - Math.min(value.length() / 3, (maxlength - 3) / 3));
				value = String.format("%s...%s", part, part2);
			}
		}

		return value;

	}

	/** @param start */
	public abstract void setStart(int start);

	/** @param end */
	public abstract void setEnd(int end);

}
