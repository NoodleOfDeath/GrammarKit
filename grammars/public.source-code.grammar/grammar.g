grammar public.source-code;

// Lexer Rules

// Whitespaces
WHITESPACE { "precedence": [ "max" ], "options": [ "skip" ] }:
	'[ \t]+';
NEWLINE { "precedence": [ "=WHITESPACE" ], "options": [ "skip" ] }:
	'\r?\n';

// Code Blocks
BLOCK { "precedence": [ "=WHITESPACE" ], "options": [ "multiline", "nested" ] }:
	L_BRACE (BLOCK | ~R_BRACE)* (R_BRACE | '\Z');

// Strings
STRING { "precedence": [ "<WHITESPACE" ], "options": [] }:
	'\"(?s:.*?)(\"|\Z)';
LITERAL_STRING { "precedence": [ "=STRING" ], "options": [] }:
	'\'(?s:.*?)(\'|\Z)';

// Token Precedence
TOKEN { "precedence": [ "<STRING" ], "options": [ "skip" ] };
	
// Block Delimiters
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

// Delimiter Tokens
COMMA { "precedence": [ "=TOKEN" ], "options": [] }:
	',';
SEMICOLON { "precedence": [ "=TOKEN" ], "options": [] }:
	'\;';
COLON { "precedence": [ "=TOKEN" ], "options": [] }:
	':';
UNDERSCORE { "precedence": [ "=TOKEN" ], "options": [] }:
	'_';

// Operator Precedence
OPERATOR { "precedence": [ "<STRING" ], "options": [ "skip" ] };
	
// Bitwise and Logic Operators
LOGIC_OPERATOR { "precedence": [ "=OPERATOR" ], "options": [] }:
	'&&' | '\|\|';
BITWISE_OPERATOR { "precedence": [ "<LOGIC_OPERATOR", ">LT_OPERATOR", ">GT_OPERATOR" ], "options": [] }:
	'<<' | '>>' | '~' | '&' | '\|';

// Comparison Operators
EQ_OPERATOR { "precedence": [ "=OPERATOR" ], "options": [] }:
	'==';
NEQ_OPERATOR { "precedence": [ "=OPERATOR" ], "options": [] }:
	'!=';
LT_OPERATOR { "precedence": [ "=OPERATOR" ], "options": [] }:
	'<';
GT_OPERATOR { "precedence": [ "=OPERATOR" ], "options": [] }:
	'>';

// Mathematical Operators
ADD_OPERATOR { "precedence": [ "=OPERATOR" ], "options": [] }:
	'\+';
SUB_OPERATOR { "precedence": [ "=OPERATOR" ], "options": [] }:
	'-';
MLT_OPERATOR { "precedence": [ "=OPERATOR" ], "options": [] }:
	'\*';
DIV_OPERATOR { "precedence": [ "=OPERATOR" ], "options": [] }:
	'/';

// Assignment Operators
EQ_ASSIGNMENT_OPERATOR { "precedence": [ "<EQ_OPERATOR", ">NUMBER" ], "options": [] }:
	'=';
INCREMENTAL_ASSIGNMENT_OPERATOR { "precedence": [ "=OPERATOR", ">ADD_OPERATOR", ">SUB_OPERATOR", ">MLT_OPERATOR", ">DIV_OPERATOR" ], "options": [] }:
	'\+=' | '-=' | '\*=' | '/=';

// Numbers
NUMBER { "precedence": [ "<OPERATOR", "<TOKEN" ], "options": [] }:
	'0x[0-9a-fA-F][0-9a-fA-F]+' | ('[0-9]+' ('\.[0-9]+')?);

ID { "precedence": [ "<NUMBER" ], "options": [] }:
	'[\p{L}\_\$][\p{L}\_\$0-9]*';
	
// Parser Fragments

fragment math_operator;

fragment logic_operator;

fragment operator:
	BITWISE_OPERATOR | LOGIC_OPERATOR | LT_OPERATOR | GT_OPERATOR | EQ_OPERATOR | ADD_OPERATOR | SUB_OPERATOR | MLT_OPERATOR | DIV_OPERATOR | INCREMENTAL_ASSIGNMENT_OPERATOR;

// Parser Rules
