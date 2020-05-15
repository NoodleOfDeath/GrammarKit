grammar public.source-code;

# --------------------------------------------------
# Lexer Rules
# --------------------------------------------------

# Whitespaces
WHITESPACE { "precedence": [ "max" ], "options": [ "skip" ] }:
	'[ \t]+';
NEWLINE { "precedence": [ "=WHITESPACE" ], "options": [ "skip" ] }:
	'\r?\n';

# Strings
STRING { "precedence": [ "<WHITESPACE" ], "options": [] }:
	'\"(?s:.*?)(?:\"|\Z)';
LITERAL_STRING { "precedence": [ "=STRING" ], "options": [] }:
	'\'(?s:.*?)(?:\'|\Z)';

# Token Precedence
TOKEN { "precedence": [ "<STRING" ], "options": [ "skip" ] };
	
# Block Delimiters
L_BRACE { "precedence": [ "=TOKEN" ], "options": [] }:
	'\{';
R_BRACE { "precedence": [ "=TOKEN" ], "options": [] }:
	'\}';
L_BRACK { "precedence": [ "=TOKEN" ], "options": [] }:
	'\[';
R_BRACK { "precedence": [ "=TOKEN" ], "options": [] }:
	'\]';
L_PAREN { "precedence": [ "=TOKEN" ], "options": [] }:
	'\(';
R_PAREN { "precedence": [ "=TOKEN" ], "options": [] }:
	'\)';

# Delimiter Tokens
COMMA { "precedence": [ "=TOKEN" ], "options": [] }:
	',';
SEMICOLON { "precedence": [ "=TOKEN" ], "options": [] }:
	'\;';
COLON { "precedence": [ "=TOKEN" ], "options": [] }:
	':';
UNDERSCORE { "precedence": [ "=TOKEN" ], "options": [] }:
	'_';
