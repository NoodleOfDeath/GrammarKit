package com.noodleofdeath.pastaparser.io.parser.impl;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import com.noodleofdeath.pastaparser.io.TokenStream;
import com.noodleofdeath.pastaparser.io.token.TextToken;
import com.noodleofdeath.pastaparser.model.grammar.Grammar;
import com.noodleofdeath.pastaparser.model.grammar.event.listener.ParserListener;
import com.noodleofdeath.pastaparser.model.grammar.rule.GrammarRule;
import com.noodleofdeath.pastaparser.model.grammar.rule.GrammarRuleType;
import com.noodleofdeath.pastaparser.model.grammar.rule.GrammarRuleComponentType;
import com.noodleofdeath.pastaparser.model.graph.tree.syntaxtree.ParserSyntaxTree;
import com.noodleofdeath.pastaparser.model.graph.tree.syntaxtree.impl.TextParserSyntaxTree;

/**
 * Base extension of {@link AbstractParser} with generic types {@link String}
 * and {@link TextToken}.
 */
public class BaseTextParser extends AbstractParser<String, TextToken> {

	/**   */
	public enum Option {

		;

		int value = 0;

		/** @param value */
		private Option(int value) {
			this.value = value;
		}

	}

	/** Constructs a new text parser with no parser grammar. */
	public BaseTextParser() {

	}

	/**
	 * Constructs a new text parser with an initial parser grammar.
	 * 
	 * @param Grammar to set for this text parser.
	 */
	public BaseTextParser(Grammar grammar) {
		super(grammar);
	}

	/**
	 * Constructs a new text parser with an initial parser grammar and parser
	 * listener.
	 *
	 * @param Grammar to set for this text parser.
	 * @param listener      to add to this text parser.
	 */
	public BaseTextParser(Grammar grammar, ParserListener<String, TextToken> listener) {
		super(grammar);
		addGrammarEventListener(listener);
	}

	@Override
	public void parse(TokenStream<String, TextToken> tokenStream, int offset) {
		if (grammar == null)
			return;
		while (offset < tokenStream.length()) {
			ParserSyntaxTree<TextToken> syntaxTree = new TextParserSyntaxTree();
			for (GrammarRule parserRule : grammar.rules(GrammarRuleType.ParserRule)) {
				syntaxTree = parse(tokenStream, parserRule, offset);
				if (syntaxTree.matches()) {
					syntaxTree.setRule(parserRule);
					break;
				}
			}
			if (syntaxTree.matches())
				didGenerateSyntaxTree(syntaxTree);
			else
				didSkipToken(tokenStream.get(0));
			offset += syntaxTree.matches() ? syntaxTree.tokenCount() : 1;
		}
	}

	@Override
	public ParserSyntaxTree<TextToken> parse(TokenStream<String, TextToken> tokenStream,
			GrammarRule parserRule, int offset, ParserSyntaxTree<TextToken> syntaxTree) {

		if (syntaxTree == null)
			syntaxTree = new TextParserSyntaxTree();
		
		syntaxTree.setRule(parserRule);

		if (!(parserRule.exists() && offset < tokenStream.length()))
			return syntaxTree;

		ParserSyntaxTree<TextToken> subtree = new TextParserSyntaxTree();
		int matchCount = 0;
		int dx = 0;

		switch (parserRule.componentType()) {

		case ParserRule:

			GrammarRule parserRuleRef = grammar().rule(parserRule.value());
			if (parserRuleRef == null) 
				return syntaxTree;

			subtree = parse(tokenStream, parserRuleRef, offset);
			while (parserRule.inverted() != subtree.absoluteMatch()) {
				if (parserRule.inverted()) {
					subtree = new TextParserSyntaxTree();
					subtree.addToken(tokenStream.get(offset + dx));
				}
				syntaxTree.addTokens(subtree.tokens());
				matchCount += 1;
				dx += subtree.tokenCount();
				if (!parserRule.quantifier().greedy())
					break;
				subtree = parse(tokenStream, parserRuleRef, offset + dx);
			}

			break;

		case Composite:

			if (parserRule.subrules().size() > 0) {

				for (GrammarRule subrule : parserRule.subrules()) {
					subtree = parse(tokenStream, subrule, offset);
					if (parserRule.inverted() != subtree.absoluteMatch())
						break;
				}

				while (parserRule.inverted() != subtree.absoluteMatch()) {
					if (parserRule.inverted()) {
						subtree = new TextParserSyntaxTree();
						subtree.addToken(tokenStream.get(offset + dx));
					}
					syntaxTree.addTokens(subtree.tokens());
					matchCount += 1;
					dx += subtree.tokenCount();
					if (!parserRule.quantifier().greedy())
						break;
					for (GrammarRule subrule : parserRule.subrules()) {
						subtree = parse(tokenStream, subrule, offset + dx);
						if (parserRule.inverted() != subtree.absoluteMatch())
							break;
					}
				}
					
			}
						
			break;

		case LexerRule:
		case LexerFragment:
			
			TextToken token = tokenStream.get(offset);
			while (parserRule.inverted() != parserRule.value().equals(token.lexerRule().id())) {
				syntaxTree.addToken(token);
				matchCount += 1;
				dx += 1;
				if (parserRule.quantifier().greedy() || offset + dx >= tokenStream.length())
					break;
				token = tokenStream.get(offset + dx);
			}
				
			break;
			
		case Expression:
		case Literal:
		default:

			token = tokenStream.get(offset);
			Matcher matcher = Pattern.compile(String.format("^%s", parserRule.value())).matcher(token.value());
			while (parserRule.inverted() != matcher.find()) {
				syntaxTree.addToken(token);
				matchCount += 1;
				dx += 1;
				if (!parserRule.quantifier().greedy() || offset + dx >= tokenStream.length())
					break;
				token = tokenStream.get(offset + dx);
			}
			
			break;
			
		}

		if (matchCount > 0 || parserRule.quantifier().optional()) {
			if (parserRule.next() != null)
				return parse(tokenStream, parserRule.next(), offset + dx, syntaxTree);
			syntaxTree.resolve();
		}
		
		return syntaxTree;

	}

	/**
	 * @param token
	 */
	private void didSkipToken(TextToken token) {
		for (ParserListener<String, TextToken> listener : listeners())
			listener.didSkipToken(this, token);
	}

	/**
	 * @param syntaxTree
	 */
	private void didGenerateSyntaxTree(ParserSyntaxTree<TextToken> syntaxTree) {
		for (ParserListener<String, TextToken> listener : listeners())
			listener.didGenerateSyntaxTree(this, syntaxTree);
	}

}
