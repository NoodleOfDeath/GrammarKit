grammar public.markup;
import public.text;

# --------------------------------------------------
# Lexer Rules
# --------------------------------------------------

fragment TAG_NAME:
	'[\p{L}][\p{L}\-0-9]*[\p{L}]?';

fragment END_TAG:
	'<' '\/' %tagName '>';

fragment ATTRIBUTE_NAME:
	'[\p{L}][\p{L}\-0-9]*[\p{L}]?';

fragment ATTRIBUTE:
	ATTRIBUTE_NAME ('=' ('\w+' | STRING | LITERAL_STRING))?;

# Elements

CLOSED_ELEMENT { "precedence" : ["<WHITESPACE"], "options": [], "groups": { "tagName": {}, "attributes": {}, "innerHtml": { "options": [ "nested" ] } } }:
	'<' (?<tagName> TAG_NAME) (?<attributes> '\s+' ATTRIBUTE)* '>' (?<innerHtml> CLOSED_ELEMENT | ~END_TAG)* END_TAG;

SINGLE_ELEMENT { "precedence" : [ "<WHITESPACE", "<CLOSED_ELEMENT" ], "options": [], "groups": { "tagName": {}, "attributes": {} } }:
	'<[\?!]?' (?<tagName> TAG_NAME) (?<attributes> '\s+' ATTRIBUTE)* '\s*\/\s*'? '\??>';
