# GrammarKit - Getting Started

In order to make the most of this engine, the developer needs to be well educated on grammar theory, syntactical analysis, and abstract syntax trees. The engine itself is only as powerful as the grammar library files it implements. The following is a simple outline of a possible workflow to incorporate this framework into an application; note that the steps are not listed in any particular order.

## Installation

### iOS/macOS - Swift (CocoaPods)

```ruby
pod 'GrammarKit'
```

### Java (Maven) - NOT YET SUPPORTED

```xml  
<dependency>
	<groupId>com.noodleofdeath</groupId>
	<artifactId>GrammarKit</artifactId>
	<version>1.0.0</version>
</dependency>
```

## Author

NoodleOfDeath, git@noodleofdeath.com

## License

GrammarKit is available under the MIT license. See the LICENSE file for more info.

## Example and Usage

### iOS/macOS - Swift (CocoaPods)

To run the example project, clone the repo, and run `pod install` from the Example directory first.

```swift
import XCTest
import GrammarKit

class Tests: XCTestCase {

    func testExample() {
        guard
            let grammarsDirectory = Bundle(for: type(of: self)).resourcePath?.ns.appendingPathComponent("grammars"),
            let sampleFile = Bundle(for: type(of: self)).path(forResource: "samples/Test", ofType: "swift")
            else { XCTFail(); return }
        let loader = GrammarLoader(searchPaths: grammarsDirectory)
        do {
            guard let grammar = loader.load(with: "public.swift-source") else { XCTFail(); return }
            let text = try String(contentsOfFile: sampleFile)
            let engine = CompoundGPEngine(grammar: grammar)
            engine.process(text, options: .verbose)
        } catch {
            print(error)
            XCTFail()
        }
    }

}
```

### Java (Maven)

To run the example project, clone the repo, and run the Eclipse project as Java Application and/or JUnit test.

```java
import static org.junit.Assert.fail;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;

import org.junit.Test;

import com.noodleofdeath.GrammarKit.io.engine.SyntaxEngine;
import com.noodleofdeath.GrammarKit.io.engine.impl.BaseTextSyntaxEngine;
import com.noodleofdeath.GrammarKit.io.lexer.Lexer;
import com.noodleofdeath.GrammarKit.io.parser.Parser;
import com.noodleofdeath.GrammarKit.io.token.TextToken;
import com.noodleofdeath.GrammarKit.model.grammar.Grammar;
import com.noodleofdeath.GrammarKit.model.grammar.loader.GrammarLoader;
import com.noodleofdeath.GrammarKit.model.grammar.loader.impl.BaseGrammarLoader;

class GrammarKitSystemTest {

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
