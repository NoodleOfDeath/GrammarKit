# GrammarKit - Grammar Structure

## Sections

* [Grammar Definition](#grammar-definition)
* [Root Grammar Element](#root-grammar-element)
    - [Grammar Attributes](#grammar-attributes)
* [Grammar Rules](#grammar-rules)
    - [Grammar Rule Attributes](#grammar-rule-attributes)
    - [Grammar Rule Definition](#grammar-rule-definition)
    - [Grammar Rule Definition Quantifiers](#grammar-rule-definition-quantifiers)
* [Grammar Events](#grammar-events)
* [Grammar Action Sequences](#grammar-action-sequences)

## Grammar Definition

In version 1.0.0, grammars are defined as a single XML file or a directory package ending in the `.grammar` suffix, which contain a single `grammar.xml` defining grammar rules. Future releases will support grammar definitions as plain text [ANTLR4](https://github.com/antlr/antlr4) `.g4` grammar files. The purpose of packaged grammars is allow for assets to be bundled together with a grammar definition in custom implementations.

*Example of Grammar Package*
```
public.source-code.grammar
  - grammar.xml
  - assets/
    - error-icon.png
```

## Root Grammar Element

GrammarKit XML grammar definitions follow many of the same rules as plain text [ANTLR4](https://github.com/antlr/antlr4) grammar definitions. At a minimum, GrammarKit XML grammar definitions are required to have a root `grammar` element. This element can have `name`, `id`, `extends`, `format-version`, `grammar-type`, and `version` attributes. **The `id` and `version` attributes are required**.

### Grammar Attributes

| Attribute | Type | Description |
|:-|:-|:-|
| `extends` | `string` | The `id` of another grammar that this grammar should extend. <br />Default value is `none`. |
| `format-version` | `number` | Version of the grammar structure. Currently, this will always equal `1.0` until changed in future releases. |
| `grammar-type` | `string` | Type of this grammar. <br />Possible values are `"lexer"`, `"parser"`, or `"compound"`. <br />Default value is `"compound"`. |
| *`id` | `string`<br />(comma and/or whitespace separated list) | Unique identifier(s) for this grammar. Can be the uniform type identifier of this grammar and/or a custom reverse-DNS string. If not specified, this value assumes the name of its parent `.grammar` package; if this `grammar.xml` file is not within a `.grammar` this attribute is must be specified. |
| `name` | `string` | Name of this grammar. <br />Default value is the `id` of this grammar. |
| *`version` | `string` | Release version of this grammar. Newer versions should have an incrementally greater version number. This value must be a number but may optionally end with the letter `"b"` to denote a beta version. |
| *required |   |  |

The `format-version` attribute will always be `1.0` until newer grammar structure models are released. 

### Grammar Type Attribute

| Grammar Type | Description |
|:-|:-|
| `"lexer"` | All grammar rules are treated as lexer rules regardless of identifier capitalization. | 
| `"parser"` | All grammar rules are treated as parser rules regardless of identifier capitalization. |
| `"compound"` | Grammar is treated as a compound grammar where grammar rules with an `id` that begins with an uppercase letter are treated as lexer rules and grammar rules with an `id` that begins with a lowercase letter are treated as parser rules. |

The `grammar-type` attribute can be one of three values: `"lexer"`, `"parser"`, or `"compound"`. If this attribute is omitted or invalid, the grammar is assumed to be a compound grammar. If `"lexer"` or `"parser"` is specified, ALL rules will be treated as either lexer rules or parser rules, respectively, regardless of the capitalization of rule identifiers. Below is a simple example of a grammar root element for an empty compound grammar:

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<grammar name="My Grammar" id="public.MyGrammar-source, com.example.MyGrammar" format-version="1.0" grammar-type="compound" version="1.0">
</grammar>
```

## Grammar Rules

Grammars are made up of grammar rules. These rules are defined as semi-regex/ANTLR4 grammar rule variants. These rules are defined in a `rules` array element under the root `grammar` element. This `rules` element should contain a sequential list of `rule` elements that define the grammar rules of this grammar. Each grammar `rule` element must have an `id` attribute, unique to the rule space of this grammar, but may also have `order` and `options` attributes as shown in the table below.

### Grammar Rule Attributes

| Attribute | Type | Description |
|:-|:-|:-|
| *`id`| `string`| Unique identifier of this grammar rule. If this value begins with a lowercase letter, it will be treated as a parser rule. If this value begins with an uppercase letter, it will be treated as a lexer rule.|
| `order`| `number`| The order of magnitude with which to prioritize scanning of this grammar rule before other grammar rules. The _lesser_ the magnitude, the higher the priority. Default value is max integer value. |
| `options`| `string` <br />(comma and/or whitespace separated list) | Options of this grammar rule. <br />Possible values are `"omit"`, `"skip"`, and/or `"multipass"`. <br />Default is `""`. |
| *required |   |  |

### Lexer Rules and Parser Rules

There are two types of grammar rules: **lexer rules** and **parser rules**. Lexer rules are used to tokenize character input streams to produce grammar events and token streams. Parser rules are then used to parse token streams and generate grammar events. Rules with an `id` that begins with a lowercase letter will be treated as lexer rules, and rules with an `id` that begins with an uppercase letter will be treated as parser rules.

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<grammar id="public.source-code" version="1.0">
    <rules>
        <!-- This is a lexer rule named "MyRule" -->
        <rule id="MyRule" order="100" options="omit skip">
            <definition>'MyRule'</definition>
            <events>
                <event>
                    
                </event>
            </events>
        </rule>
    </rules>
</grammar>
```

#### Order Attribute

The `order` attribute defines the priority of the rule. Rules with _lesser_ order, by default, will be tested against an input stream _before_ rules with _greater_ order. This attribute is used to sort rules by calling the `sortRules` method of the `Grammar` class.

#### Options Attribute

The `options` attribute of a rule tells the lexer/parser scanner how to handle events when this rule matches a sequence in an input stream. Multiple options can be listed in this attribute separated by at least a single whitespace character and/or a single comma. If the `skip` option is specified, matches to this rule will not fire a grammar event to pass on to listeners/delegates. A skipped match will still terminate scanning of other rules of greater order as well as increment the current index of the input stream. An example of this would be to skip all whitespace character matches but continue to advance forward in the input stream. If the `omit` option is specified, the rule will not be added to the queue of matchable rules, however, it can be referenced by other rules by `id`. An example of using this would be when several rules reuse a rule expression, but the rule expression by itself should not generate a grammar event upon scanning.

### Grammar Rule Definition

A grammar rule must contain a single `definition` element that specifies a sequence of patterns and/or subrules that when encountered in an input stream will generate a grammar event. Single quoted strings will be treated as raw regular expression. Rules may reference other rules, and even reference themeselves recursively as long as they are not fatally recursive causing an infinte loop. Lexer rules may reference other lexer rules, but NOT parser rules. Parser rules may reference both lexer and parser rules.

#### Grammar Rule Definition Quantifiers

Each component in a rule definition may also have a postfix quantifier operator indicating how many times to match that component in a sequence and/or if it is an optional component. For example, this can be defined both as a regular expression and as a postfix quantifier as shown below.

| Quantifier | Name | Description | Optional | Greedy | Lazy
|:-|:-|:-|:-|:-|:-|
| `.*` | `NoneOrMore` |  Match none or more times | Yes | Yes | No |
| `.*?` | `NoneOrMoreLazy` | Match none or more times, prefer fewer | Yes | Yes | Yes |
| ` ` | `Once` | Match once (default) | No | No | No |
| `+` | `OnceOrMore` | Match once or more | No | Yes | No |
| `+?` | `OnceOrMoreLazy` | Match once or more, prefer fewer | No | Yes | Yes |
| `?` | `Optional` | Match none or just once | Yes | No | No |
| `??` | `OptionalLazy` | Match none or just once, prefer none. | Yes | No | Yes |

```xml
<rules>
    <!-- This is a lexer rule because it begins with a capital letter. -->
    <rule id="SPACE" order="1" options="skip">
        <definition>'[ ]'</definition>
    </rule>
    <!-- This is another lexer rule. -->
    <rule id="TAB" order="1" options="skip">
        <definition>'\t'</definition>
    </rule>
    <!-- This is a parser rule because it begins with a lowercase letter. -->
    <rule id="four-whitespaces" order="1" category="whitespace" options="skip">
        <definition>(SPACE || TAB){4}</definition>
    </rule>
</rules>
```

## Grammar Events

Grammar rules can additionally contain an `events` element containing a sequential list of `event` elements representing grammar events to be passed to the lexer/parser scanner that is implementing this grammar on an input stream. Grammar events must have a `trigger` attribute that contains a comma and/or whitespace separated list of triggers; alternatively, an event may have a child `triggers` array element containing a sequential list of `trigger` elements for each trigger, in the case where triggers for an event are more complex.

```xml
<rules>
    <rule id="NUMBER" order="7000" category="number" options="">
        <definition>'0x[0-9a-fA-F][0-9a-fA-F]+' | ('[0-9]+' ('\.[0-9]+')?)</definition>
        <events>
            <event trigger="onmatch">
                <actions>
                    <action type="assign" target="token">
                    </action>
                </actions>
            </event>
            <event>
                <triggers>
                    <trigger type="onmatch" max-retries="3" />
                </triggers>
                <actions sequence="A" />
            </event>
        </events>
    </rule>
</rules>
```

## Grammar Action Sequences

Grammars can also define action sequences that are reused repetitively and can accept parameters that may vary at runtime.

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<grammar>
    <rules>
        <rule id="NUMBER" order="7000" category="number" options="">
            <definition>'0x[0-9a-fA-F][0-9a-fA-F]+' | ('[0-9]+' ('\.[0-9]+')?)</definition>
            <events>
                <event trigger="onmatch">
                    <triggers>
                        <trigger type="onmatch" max-retries="3" />
                    </triggers>
                    <actions sequence="A" />
                </event>
            </events>
        </rule>
    </rules>
    <events>
        <event>onmatch: rule(NUMBER) -> A($1, $2)</event>
        <event>
            <trigger>onmatch: rule(NUMBER)</trigger>
            <actions>
                <action>
                </action>
            </actions>
        </event>
    </events>
    <sequences>
        <sequence id="A">
            <params>
                <param name="a" type="string" />
                <param name="b" type="number" />
            </params>
            <actions>
                <action>
                
                </action>
            </actions>
        </sequence>
    </sequences>
</grammar>
```
