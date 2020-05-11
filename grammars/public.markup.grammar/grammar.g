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
	'[\p{L}][\p{L}\-0-9]*[\p{L}]?\b';

fragment ATTRIBUTE_NAME:
	'[\p{L}][\p{L}\-0-9]*[\p{L}]?\b';

fragment ATTRIBUTE:
	ATTRIBUTE_NAME '=' (STRING | LITERAL_STRING);

# Elements
ELEMENT { "precedence" : ["<WHITESPACE"], "options": [], "groups": { "a": {}, "b": { "options": [ "nested" ] }, "c": {} } }:
	'<' (?<a> TAG_NAME) ATTRIBUTE* '>' (?<b> ELEMENT | ~('<' '/' %a '>'))* '<' '/' (?<c> %a) '>';
