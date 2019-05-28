# PastaParser (Java)

The following is the JUnit test included with the PastaParser Eclipse Java Project.

## Usage

```java
import static org.junit.Assert.fail;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;

import org.junit.Test;

import com.noodleofdeath.pastaparser.io.engine.SyntaxEngine;
import com.noodleofdeath.pastaparser.io.engine.impl.BaseTextSyntaxEngine;
import com.noodleofdeath.pastaparser.io.lexer.Lexer;
import com.noodleofdeath.pastaparser.io.parser.Parser;
import com.noodleofdeath.pastaparser.io.token.TextToken;
import com.noodleofdeath.pastaparser.model.grammar.Grammar;
import com.noodleofdeath.pastaparser.model.grammar.loader.GrammarLoader;
import com.noodleofdeath.pastaparser.model.grammar.loader.impl.BaseGrammarLoader;

class PastaParserSystemTest {

	private static String SAMPLES_DIRECTORY = "../../samples";
	private static String GRAMMARS_DIRECTORY = "../../grammars";

	public static void main(String[] args) throws Exception {
		testGrammar();
	}

	@Test
	public static void testGrammar() throws Exception {

		File file = new File(SAMPLES_DIRECTORY + "/Test.swift");
		FileInputStream fis;
		String characterStream = "";
		try {
			fis = new FileInputStream(file);
			byte[] data = new byte[(int) file.length()];
			fis.read(data);
			fis.close();
			characterStream = new String(data, "UTF-8");
		} catch (FileNotFoundException error) {
			error.printStackTrace();
			fail();
		} catch (IOException error) {
			error.printStackTrace();
			fail();
		}

		GrammarLoader loader = new BaseGrammarLoader(GRAMMARS_DIRECTORY);
		
		Grammar grammar = loader.load("public.swift-source");
		SyntaxEngine<String, TextToken, Lexer<String, TextToken>, Parser<String, TextToken>> engine = new BaseTextSyntaxEngine(grammar);
		engine.process(characterStream, true);

	}

}
```
