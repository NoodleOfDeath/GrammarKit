package com.noodleofdeath.pastaparser.model.grammar.loader.impl;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.regex.Matcher;

import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

import com.noodleofdeath.pastaparser.Quantifier;
import com.noodleofdeath.pastaparser.model.grammar.Grammar;
import com.noodleofdeath.pastaparser.model.grammar.GrammarRuleGenerator;
import com.noodleofdeath.pastaparser.model.grammar.exception.GrammarException;
import com.noodleofdeath.pastaparser.model.grammar.exception.GrammarInitializationException;
import com.noodleofdeath.pastaparser.model.grammar.impl.BaseGrammar;
import com.noodleofdeath.pastaparser.model.grammar.loader.GrammarLoader;
import com.noodleofdeath.pastaparser.model.grammar.pattern.GrammarPattern;
import com.noodleofdeath.pastaparser.model.grammar.pattern.GrammarPattern.Flag;
import com.noodleofdeath.pastaparser.model.grammar.rule.GrammarRuleComponentType;
import com.noodleofdeath.pastaparser.model.grammar.rule.GrammarRule;
import com.noodleofdeath.pastaparser.model.grammar.rule.GrammarRuleType;
import com.noodleofdeath.pastaparser.model.grammar.rule.impl.BaseGrammarRule;

public class BaseGrammarLoader implements GrammarLoader, GrammarRuleGenerator {

	/**
	 * 
	 */
	protected String[] searchPaths;

	/**
	 * 
	 *
	 * @param searchPaths
	 */
	public BaseGrammarLoader(String... searchPaths) {
		this.searchPaths = searchPaths;
	}

	/**
	 * @param path
	 * @return
	 */
	public static String ParsePackageName(String path) {
		if (path.endsWith(String.format(".%s", PACKAGE_EXTENSION))
				|| path.endsWith(String.format("%s", PACKAGE_CONFIG_FILE)))
			return ParseConfigPath(path);
		return ParseConfigPath(String.format("%s.%s", path, PACKAGE_EXTENSION));
	}

	/**
	 * @param path
	 * @return
	 */
	public static String ParseConfigPath(String path) {
		if (path.endsWith(String.format("%s", PACKAGE_CONFIG_FILE)))
			return path;
		return String.format("%s/%s", path, PACKAGE_CONFIG_FILE);
	}

	@Override
	public String[] searchPaths() {
		return searchPaths;
	}

	@Override
	public Grammar load(String id) {

		File file = new File("");
		for (String searchPath : searchPaths) {
			file = new File(ParsePackageName(String.format("%s/%s", searchPath, id)));
			if (file.exists())
				break;
		}

		try {
			Document definition = DocumentBuilderFactory.newInstance().newDocumentBuilder()
					.parse(new File(file.getPath()));
			return load(definition);
		} catch (ParserConfigurationException e) {
			e.printStackTrace();
		} catch (SAXException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;

	}

	/**
	 * @param grammarDefinition
	 * @throws Exception
	 */
	protected Grammar load(Document grammarDefinition) throws Exception {

		grammarDefinition.getDocumentElement().normalize();

		Element root = grammarDefinition.getDocumentElement();
		if (!root.getNodeName().equals(XMLTag.Grammar))
			throw new GrammarInitializationException();

		Grammar grammar = new BaseGrammar();
		GrammarRule rootRule = new BaseGrammarRule();
		HashMap<String, GrammarRule> ruleMap = new LinkedHashMap<>();

		String parentName = root.getAttribute(XMLAttribute.Extends);
		Grammar parentGrammar = null;
		if (parentName != null && parentName.length() > 0) {
			parentGrammar = load(parentName);
			rootRule = parentGrammar.rootRule();
			ruleMap = parentGrammar.ruleMap();
		}

		GrammarRule unmatchedRule = parseCompositeRule(UnmatchedRuleId, UnmatchedRuleDefinition, true, null, rootRule,
				grammar);
		unmatchedRule.setRuleType(GrammarRuleType.LexerRule);
		rootRule.addChild(unmatchedRule);

		if (root.getElementsByTagName(XMLTag.Rules).getLength() < 1)
			throw new GrammarInitializationException();

		Node ruleSet = root.getElementsByTagName(XMLTag.Rules).item(0);
		if (ruleSet.getNodeType() != 1)
			throw new GrammarInitializationException();

		NodeList nodes = ((Element) ruleSet).getElementsByTagName(XMLTag.Rule);
		for (int i = 0; i < nodes.getLength(); ++i) {
			Node node = nodes.item(i);
			if (node.getNodeType() != 1)
				continue;
			GrammarRule rule = parseNode((Element) node, rootRule, grammar);
			if (rule == null)
				continue;
			GrammarRuleType ruleType = (rule.id().substring(0, 1).toUpperCase().equals(rule.id().substring(0, 1)))
					? GrammarRuleType.LexerRule
					: GrammarRuleType.ParserRule;
			rule.setRuleType(ruleType);
			if (!rule.options().contains(XMLAttribute.Omit))
				rootRule.addChild(rule);
			ruleMap.put(rule.id(), rule);
		}

		grammar.setRootRule(rootRule);
		grammar.setRuleMap(ruleMap);
		grammar.sortRules();

		return grammar;

	}

	protected GrammarRule parseNode(Element node, GrammarRule rootRule, Grammar grammar) throws Exception {
		String id = node.getAttribute(XMLAttribute.Id);
		String definition = "";
		Node defNode = node.getElementsByTagName(XMLTag.Definition).item(0);
		if (defNode == null)
			return null;
		NodeList defNodes = null;
		if (defNode.getNodeType() == Node.ELEMENT_NODE)
			defNodes = ((Element) defNode).getElementsByTagName(XMLTag.Word);
		if (defNodes != null && defNodes.getLength() > 0) {
			List<String> defs = new ArrayList<>();
			for (int j = 0; j < defNodes.getLength(); j++)
				defs.add(String.format("'%s'", defNodes.item(j).getTextContent().replaceAll("\\r?\\n|\\s\\s+", " ")));
			definition = String.join(" | ", defs);
		} else {
			definition = defNode.getTextContent().replaceAll("\\r?\\n|\\s\\s+", " ");
		}
		GrammarRule rule = parseCompositeRule(id, definition, true, null, rootRule, grammar);
		if (checkFatal(rule))
			return null;
		String _order = node.getAttribute(XMLAttribute.Order);
		int order = _order != null ? Integer.parseInt(_order) : Integer.MAX_VALUE;
		rule.setOrder(order);
		List<String> categories = Arrays.asList(node.getAttribute(XMLAttribute.Category).split("[ ,]"));
		rule.setCategories(categories);
		List<String> options = Arrays.asList(node.getAttribute(XMLAttribute.Options).split("[ ,]"));
		rule.setOptions(options);
		return rule;
	}

	/**
	 * @param id
	 * @param atom
	 * @param quantifier
	 * @param parent
	 * @return
	 * @throws Exception
	 */
	protected GrammarRule parseAtom(String id, String atom, String quantifier, GrammarRule parent, Grammar grammar)
			throws Exception {

		GrammarRuleComponentType componentType = GrammarRuleComponentType.Atom;
		GrammarRule rule = null;

		Matcher exprMatcher = GrammarPattern.CGExpression.matcher(atom);
		if (exprMatcher.matches()) {
			atom = exprMatcher.group(1);
			componentType = GrammarRuleComponentType.Expression;
		} else {
			Matcher literalMatcher = GrammarPattern.CGLiteral.matcher(atom);
			if (literalMatcher.matches()) {
				atom = literalMatcher.group(1);
				componentType = GrammarRuleComponentType.Literal;
			} else {
				Matcher subAtomMatcher = GrammarPattern.CGGroup.matcher(atom);
				if (subAtomMatcher.matches()) {
					atom = subAtomMatcher.group(1);
					componentType = GrammarRuleComponentType.Composite;
				}
			}
		}

		if (componentType == GrammarRuleComponentType.Atom) {
			String fc = Character.toString(atom.charAt(0));
			componentType = fc.equals(fc.toUpperCase()) ? GrammarRuleComponentType.LexerRule
					: GrammarRuleComponentType.ParserRule;
		}

		if (componentType == GrammarRuleComponentType.Composite) {

			String slice = "";
			String remainder = "";

			GrammarRule tail = null;
			GrammarRule next = null;

			int depth = 0;
			int cursor = 0;
			boolean ignore = false;

			// Capture parenthesized group character by character.
			do {

				String ch = Character.toString(atom.charAt(cursor));
				slice += ch;

				switch (ch) {

				case "'":
				case "\"":
					ignore = !ignore;
					break;

				case "(":
					if (!ignore)
						++depth;
					break;

				case ")":
					if (!ignore)
						--depth;
					break;

				default:
					break;

				}

				++cursor;

			} while (depth > 0 && cursor < atom.length());

			if (depth > 0)
				throw new GrammarException("Encountered unmatched parenthesis in rule definition");

			if (cursor < atom.length()) {

				remainder = atom.substring(cursor);
				Matcher quantifierMatcher = GrammarPattern.Quantifier.matcher(remainder,
						Flag.StartAnchor + Flag.IgnoreWhitespaces);
				if (quantifierMatcher.find()) {
					quantifier = quantifierMatcher.group();
					remainder = remainder.substring(quantifier.toString().length());
				}
				int altIndex = remainder.indexOf("|");
				int grpIndex = remainder.indexOf("(");
				if (altIndex > 0) {
					if (grpIndex < 0 || altIndex < grpIndex) {
						String subslice = remainder.substring(altIndex + 1);
						next = parseCompositeRule(id, subslice, false, null, parent, grammar);
						remainder = remainder.substring(0, altIndex);
					}
				}
				tail = parseCompositeRule(id, remainder, false, null, parent, grammar);

			}

			if (slice.length() > 0) {
				Matcher cgPureGroup = GrammarPattern.CGGreedyGroup.matcher(slice);
				if (cgPureGroup.find())
					slice = cgPureGroup.group(1);
			}

			rule = parseCompositeRule(id, slice, true, null, parent, grammar);
			if (tail != null)
				rule.setNext(tail);
			if (next != null && parent != null)
				parent.enqueue(next);

		} else {
			rule = generateRule(id, atom, grammar);
		}

		rule.setRuleComponentType(componentType);
		rule.setQuantifier(Quantifier.from(quantifier));
		rule.setRootAncestor(parent);

		return rule;

	}

	/**
	 * @param id
	 * @param definition
	 * @param parent
	 * @return
	 * @throws Exception
	 */
	protected GrammarRule parseSimpleRule(String id, String definition, GrammarRule parent, Grammar grammar)
			throws Exception {
		GrammarRule orig = null;
		GrammarRule last = null;
		GrammarRule rule = null;
		Matcher atomMatcher = GrammarPattern.CGAtom.matcher(definition);
		while (atomMatcher.find()) {
			String prefix = atomMatcher.group(1);
			String atom = atomMatcher.group(2);
			String quantifier = atomMatcher.group(3);
			rule = parseAtom(id, atom, quantifier, parent, grammar);
			if (prefix != null) {
				rule.setInverted(prefix.equals("~"));
			}
			if (last != null)
				last.setNext(rule);
			last = rule;
			if (orig == null)
				orig = rule;
		}
		return orig;
	}

	/**
	 * @param id
	 * @param definition
	 * @param parent
	 * @param rootAncestor
	 * @return
	 */
	protected GrammarRule parseCompositeRule(String id, String definition, boolean composite, GrammarRule parent,
			GrammarRule rootAncestor, Grammar grammar) throws Exception {

		GrammarRule rule = null;
		if (composite) {

			rule = generateRule(id);
			rule.setGrammar(grammar);
			rule.setRuleComponentType(GrammarRuleComponentType.Composite);
			parent = rule;

			Matcher matcher = GrammarPattern.CGAlt.matcher(definition);
			while (matcher.find()) {
				String alt = matcher.group().trim();
				GrammarRule simpleRule = parseSimpleRule(id, alt, parent, grammar);
				if (simpleRule != null)
					parent.addChild(simpleRule);
				parent.consumeQueue();
			}

		} else {

			rule = parseSimpleRule(id, definition, parent, grammar);
			if (rule != null) {
				rule.setGrammar(grammar);
				if (parent != null)
					parent.setNext(rule);
			}

		}

		return rule;

	}

	/**
	 * @param rule
	 * @return
	 */
	protected static boolean checkFatal(GrammarRule rule) {
		if (rule.recursive() && rule.recursiveFatal()) {
			System.err.println(String.format(
					"WARNING: Encountered a fatal recursive rule \"%s\" defined by \"%s\". Skipping this rule.",
					rule.id(), rule));
			return true;
		}
		return false;
	}

	@Override
	public GrammarRule generateRule(String id, String ruleDefinition, GrammarRuleComponentType componentType,
			Grammar grammar) {
		return new BaseGrammarRule(id, ruleDefinition, componentType, grammar);
	}

}
