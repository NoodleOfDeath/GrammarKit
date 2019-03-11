package com.noodleofdeath.pastaparser.io.lexer.impl;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import com.noodleofdeath.pastaparser.io.TokenStream;
import com.noodleofdeath.pastaparser.io.impl.BaseTokenStream;
import com.noodleofdeath.pastaparser.io.lexer.Lexer;
import com.noodleofdeath.pastaparser.io.token.TextToken;
import com.noodleofdeath.pastaparser.io.token.impl.BaseTextToken;
import com.noodleofdeath.pastaparser.model.grammar.Grammar;
import com.noodleofdeath.pastaparser.model.grammar.event.listener.LexerListener;
import com.noodleofdeath.pastaparser.model.grammar.rule.GrammarRule;
import com.noodleofdeath.pastaparser.model.grammar.rule.GrammarRuleType;
import com.noodleofdeath.pastaparser.model.graph.tree.syntaxtree.LexerSyntaxTree;
import com.noodleofdeath.pastaparser.model.graph.tree.syntaxtree.impl.TextLexerSyntaxTree;

/**
 * Base extension of {@link AbstractLexer} with generic types {@link String} and
 * {@link TextToken}.
 */
public class BaseTextLexer extends AbstractLexer<String, TextToken> implements Lexer<String, TextToken> {

	/** Constructs a new text lexer with no lexer grammar. */
	public BaseTextLexer() {

	}

	/**
	 * Constructs a new text lexer with an initial lexer grammar and lexer listener.
	 * 
	 * @param Grammar to set for this text lexer.
	 */
	public BaseTextLexer(Grammar grammar) {
		super(grammar);
	}

	/**
	 * Constructs a new text lexer with an initial lexer grammar.
	 * 
	 * @param Grammar  to set for this text lexer.
	 * @param listener to add to this text lexer.
	 */
	public BaseTextLexer(Grammar grammar, LexerListener<String, TextToken> listener) {
		super(grammar, listener);
	}

	@Override
	public TokenStream<String, TextToken> tokenize(CharSequence characterStream, int offset) {
		if (grammar == null)
			return null;
		TokenStream<String, TextToken> tokenStream = new BaseTokenStream<>();
		while (offset < characterStream.length()) {
			LexerSyntaxTree<String, TextToken> syntaxTree = new TextLexerSyntaxTree();
			for (GrammarRule rule : grammar.rules(GrammarRuleType.LexerRule)) {
				syntaxTree = tokenize(characterStream, rule, offset);
				if (syntaxTree.matches()) {
					syntaxTree.setRule(rule);
					break;
				}
			}
			if (syntaxTree.matches() && !syntaxTree.rule().skip()) {
				tokenStream.addToken(syntaxTree.generateToken());
				if (syntaxTree.rule().equals(grammar.unmatchedRule()))
					didNotMatchToken(syntaxTree.generateToken());
				else
					didGenerateSyntaxTree(syntaxTree);
			}
			offset += syntaxTree.matches() ? syntaxTree.length() : 1;
		}
		return tokenStream;
	}

	@Override
	public LexerSyntaxTree<String, TextToken> tokenize(CharSequence characterStream, GrammarRule rule, int offset,
			LexerSyntaxTree<String, TextToken> syntaxTree) {

		if (syntaxTree == null)
			syntaxTree = new TextLexerSyntaxTree();
		syntaxTree.setRule(rule);

		if (!(rule.exists() && offset < characterStream.length()))
			return syntaxTree;

		String stream = characterStream.subSequence(offset, characterStream.length()).toString();

		if (stream.length() < 1)
			return syntaxTree;

		LexerSyntaxTree<String, TextToken> subtree = new TextLexerSyntaxTree();
		int matchCount = 0;
		int dlength = 0;

		switch (rule.componentType()) {

		case LexerRule:
		case LexerFragment:

			GrammarRule lexerRuleRef = grammar().rule(rule.value());
			if (lexerRuleRef == null) {
				return syntaxTree;
			}

			subtree = tokenize(characterStream, lexerRuleRef, offset, null);
			while (rule.inverted() != subtree.absoluteMatch()) {
				if (rule.inverted()) {
					TextToken token = new BaseTextToken(rule, Character.toString(stream.charAt(0)), offset + dlength,
							offset + dlength + 1);
					subtree = new TextLexerSyntaxTree();
					subtree.addToken(token);
				}
				syntaxTree.addTokens(subtree.tokens());
				matchCount += 1;
				dlength += subtree.length();
				if (!rule.quantifier().greedy())
					break;
				subtree = tokenize(characterStream, lexerRuleRef, offset + dlength, null);
			}

			break;

		case Composite:

			if (rule.subrules().size() > 0) {

				for (GrammarRule subrule : rule.subrules()) {
					subtree = tokenize(characterStream, subrule, offset);
					if (rule.inverted() != subtree.absoluteMatch())
						break;
				}

				while (rule.inverted() != subtree.absoluteMatch()) {
					if (rule.inverted()) {
						TextToken token = new BaseTextToken(rule, Character.toString(stream.charAt(0)),
								offset + dlength, offset + dlength + 1);
						subtree = new TextLexerSyntaxTree();
						subtree.addToken(token);
					}
					syntaxTree.addTokens(subtree.tokens());
					matchCount += 1;
					dlength += subtree.length();
					if (!rule.quantifier().greedy())
						break;
					for (GrammarRule subrule : rule.subrules()) {
						subtree = tokenize(characterStream, subrule, offset + dlength);
						if (rule.inverted() != subtree.absoluteMatch())
							break;
					}
				}

			}

			break;

		case Expression:
		case Literal:
		default:

			Matcher matcher = Pattern.compile(String.format("^%s", rule.value())).matcher(stream);

			while (rule.inverted() != matcher.find()) {
				TextToken token = null;
				if (rule.inverted()) {
					token = new BaseTextToken(rule, Character.toString(stream.charAt(0)), offset + dlength,
							offset + dlength + 1);
				} else {
					int start = offset + dlength + matcher.start();
					int end = offset + dlength + matcher.end();
					token = new BaseTextToken(rule, matcher.group(), start, end);
				}
				syntaxTree.addToken(token);
				matchCount += 1;
				dlength += token.length();
				if (!rule.quantifier().greedy())
					break;
			}

			break;

		}

		if (matchCount > 0 || rule.quantifier().optional()) {
			if (rule.next() != null)
				return tokenize(characterStream, rule.next(), offset + dlength, syntaxTree);
			syntaxTree.resolve();
		}

		return syntaxTree;

	}

	/**
	 * @param syntaxTree
	 */
	private void didGenerateSyntaxTree(LexerSyntaxTree<String, TextToken> syntaxTree) {
		for (LexerListener<String, TextToken> listener : listeners())
			listener.didGenerateSyntaxTree(this, syntaxTree);
	}

	/**
	 * @param syntaxTree
	 */
	private void didNotMatchToken(TextToken token) {
		for (LexerListener<String, TextToken> listener : listeners())
			listener.didNotMatchToken(this, token);
	}

}
