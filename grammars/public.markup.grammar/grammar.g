grammar public.markup;
import public.text;

# --------------------------------------------------
# Lexer Rules
# --------------------------------------------------

# Whitespaces
WHITESPACE { "precedence": [ "max" ], "options": [ "skip" ] }:
	'[ \t]+';
NEWLINE { "precedence": [ "=WHITESPACE" ], "options": [ "skip" ] }:
	'\r?\n';

fragment TAG_NAME:
	'[\p{L}][\p{L}\-0-9]*[\p{L}]?';

fragment END_TAG:
	'<' '\/' %tag '>';

fragment ATTRIBUTE_NAME:
	'[\p{L}][\p{L}\-0-9]*[\p{L}]?';

fragment ATTRIBUTE:
	ATTRIBUTE_NAME ('=' ('\w+' | STRING | LITERAL_STRING))?;

# Elements

CLOSED_ELEMENT { "precedence" : ["<WHITESPACE"], "options": [], "groups": { "tag": {}, "b": {}, "c": { "options": [ "nested" ] } } }:
	'<' (?<tag> TAG_NAME) (?<b> '\s+' ATTRIBUTE)* '>' (?<c> CLOSED_ELEMENT | ~END_TAG)* END_TAG;

SINGLE_ELEMENT { "precedence" : [ "<WHITESPACE", "<ELEMENT" ] }:
	'<' (?<tag> TAG_NAME) (?<b> '\s+' ATTRIBUTE)* '\s*\/\s*'? '>';
