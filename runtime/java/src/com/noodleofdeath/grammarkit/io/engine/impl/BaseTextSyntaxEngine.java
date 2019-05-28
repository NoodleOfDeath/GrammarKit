package com.noodleofdeath.pastaparser.io.engine.impl;

import com.noodleofdeath.pastaparser.io.TokenStream;
import com.noodleofdeath.pastaparser.io.lexer.Lexer;
import com.noodleofdeath.pastaparser.io.lexer.impl.BaseTextLexer;
import com.noodleofdeath.pastaparser.io.parser.Parser;
import com.noodleofdeath.pastaparser.io.parser.impl.BaseTextParser;
import com.noodleofdeath.pastaparser.io.token.TextToken;
import com.noodleofdeath.pastaparser.model.grammar.Grammar;
import com.noodleofdeath.pastaparser.model.grammar.rule.GrammarRuleType;
import com.noodleofdeath.pastaparser.model.graph.tree.syntaxtree.LexerSyntaxTree;
import com.noodleofdeath.pastaparser.model.graph.tree.syntaxtree.ParserSyntaxTree;

/**
 * 
 */
public class BaseTextSyntaxEngine
		extends AbstractSyntaxEngine<String, TextToken, Lexer<String, TextToken>, Parser<String, TextToken>> {

	/**
	 *
	 * @param grammar
	 */
	public BaseTextSyntaxEngine(Grammar grammar) {
		super(new BaseTextLexerEngine(new BaseTextLexer(grammar), false),
				new BaseTextParserEngine(new BaseTextParser(grammar), false));
	}

	@Override
	public void didGenerateSyntaxTree(Lexer<String, TextToken> lexer, LexerSyntaxTree<String, TextToken> syntaxTree) {
		super.didGenerateSyntaxTree(lexer, syntaxTree);
	}

	@Override
	public void didNotMatchToken(Lexer<String, TextToken> lexer, TextToken token) {
		super.didNotMatchToken(lexer, token);
	}

	@Override
	public void didGenerateSyntaxTree(Parser<String, TextToken> parser, ParserSyntaxTree<TextToken> syntaxTree) {
		super.didGenerateSyntaxTree(parser, syntaxTree);
		for (TextToken token : syntaxTree.tokens())
			if (token.lexerRule().options().contains("retokenize"))
				tokenize(token);
	}

	@Override
	public void didSkipToken(Parser<String, TextToken> parser, TextToken token) {
		super.didSkipToken(parser, token);
	}

	@Override
	public Lexer<String, TextToken> lexer() {
		return lexerEngine.lexer();
	}

	@Override
	public Parser<String, TextToken> parser() {
		return parserEngine.parser();
	}

	@Override
	public void process(CharSequence characterStream, boolean verbose) {

		this.verbose = verbose;

		if (verbose) {
			System.out.println();
			System.out.println("----- Listing Lexer Rules -----");
			System.out.println();
			lexerEngine.lexer().grammar().printRules(GrammarRuleType.LexerRule);
			System.out.println();
			System.out.println("----- Listing Parser Rules -----");
			System.out.println();
			parserEngine.parser().grammar().printRules(GrammarRuleType.ParserRule);
		}

		if (verbose) {
			System.out.println();
			System.out.println("----- Tokenizing Character Stream -----");
			System.out.println();
		}

		TokenStream<String, TextToken> tokenStream = lexerEngine.tokenize(characterStream);

		if (verbose) {
			System.out.println();
			System.out.println("----- Parsing Token Stream -----");
			System.out.println();
		}

		parserEngine.parse(tokenStream);

	}

	/**
	 * @param token
	 */
	private void tokenize(TextToken token) {
		if (verbose) {
			System.out.println();
			System.out.println(String.format(">> Parsing Block: \" %s\"(%d, %d)[%d] <<",
					token.text(TextToken.StringOptionEscaped + TextToken.StringOptionTruncate), token.start(),
					token.end(), token.length()));
			System.out.println();
		}
		TokenStream<String, TextToken> tokenStream = lexer()
				.tokenize(token.text(TextToken.StringOptionStripOuterBraces));
		parser().parse(tokenStream);
	}

}
