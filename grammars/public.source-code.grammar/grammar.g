grammar public.source-code;
import public.text;

# --------------------------------------------------
# Lexer Rules
# --------------------------------------------------

# Code Blocks
BLOCK { "precedence": [ "<WHITESPACE" ], "options": [], "groups": { "a": { "options": [ "nested" ] } } }:
	L_BRACE (?<a> BLOCK | ~R_BRACE)* (R_BRACE | '\Z');

# Operator Precedence
OPERATOR { "precedence": [ "<TOKEN" ], "options": [ "skip" ] };
	
# Logic Operators
AND_LOGIC_OPERATER { "precedence": [ "=OPERATOR" ], "options": [] }:
	'&&';
OR_LOGIC_OPERATER { "precedence": [ "=OPERATOR" ], "options": [] }:
	'\|\|';

fragment LOGIC_OPERATOR:
	AND_LOGIC_OPERATER | OR_LOGIC_OPERATOR;

# Bitwise Operators
BITWISE_SHIFT_LEFT_OPERATOR { "precedence": [ ">LT_OPERATOR", "=OPERATOR" ], "options": [] }:
	'<<';
BITWISE_SHIFT_RIGHT_OPERATOR { "precedence": [ ">GT_OPERATOR", "=OPERATOR" ], "options": [] }:
	'>>';
BITWISE_NOT_OPERATOR { "precedence": [ "=OPERATOR" ], "options": [] }:
	'~';
BITWISE_AND_OPERATOR { "precedence": [ "<AND_LOGIC_OPERATER", "=OPERATOR" ], "options": [] }:
	'&';
BITWISE_OR_OPERATOR { "precedence": [ "<OR_LOGIC_OPERATER", "=OPERATOR" ], "options": [] }:
	'\|';

fragment BITWISE_OPERATOR:
	BITWISE_SHIFT_LEFT_OPERATOR | BITWISE_SHIFT_RIGHT_OPERATOR | BITWISE_NOT_OPERATOR | BITWISE_AND_OPERATOR | BITWISE_OR_OPERATOR;

# Comparison Operators
EQ_OPERATOR { "precedence": [ "=OPERATOR" ], "options": [] }:
	'==';
NEQ_OPERATOR { "precedence": [ "=OPERATOR" ], "options": [] }:
	'!=';
LTE_OPERATOR { "precedence": [ "=OPERATOR", ">LT_OPERATOR" ], "options": [] }:
	'<=';
LT_OPERATOR { "precedence": [ "=OPERATOR" ], "options": [] }:
	'<';
GTE_OPERATOR { "precedence": [ "=OPERATOR", ">GT_OPERATOR" ], "options": [] }:
	'>=';
GT_OPERATOR { "precedence": [ "=OPERATOR" ], "options": [] }:
	'>';

fragment COMPARISON_OPERATOR:
	LT_OPERATOR | LTE_OPERATOR | EQ_OPERATOR | NEQ_OPERATOR | GT_OPERATOR | GTE_OPERATOR;

# Mathematical Operators
ADD_OPERATOR { "precedence": [ "=OPERATOR" ], "options": [] }:
	'\+';
SUB_OPERATOR { "precedence": [ "=OPERATOR" ], "options": [] }:
	'-';
MLT_OPERATOR { "precedence": [ "=OPERATOR" ], "options": [] }:
	'\*';
DIV_OPERATOR { "precedence": [ "=OPERATOR" ], "options": [] }:
	'/';

fragment MATH_OPERATOR:
	ADD_OPERATOR | SUB_OPERATOR | MLT_OPERATOR | DIV_OPERATOR;

# Assignment Operators
EQ_ASSIGNMENT_OPERATOR { "precedence": [ "<EQ_OPERATOR", ">NUMBER" ], "options": [] }:
	'=';
INCREMENTAL_ASSIGNMENT_OPERATOR { "precedence": [ "=OPERATOR", ">ADD_OPERATOR", ">SUB_OPERATOR", ">MLT_OPERATOR", ">DIV_OPERATOR" ], "options": [] }:
	'\+=' | '-=' | '\*=' | '/=';

fragment ASSIGNMENT_OPERATOR:
	EQ_ASSIGNMENT_OPERATOR | INCREMENTAL_ASSIGNMENT_OPERATOR;

# Numbers
NUMBER { "precedence": [ "<OPERATOR", "<TOKEN" ], "options": [] }:
	'0x[0-9a-fA-F][0-9a-fA-F]+' | ('[0-9]+' ('\.[0-9]+')?);

ID { "precedence": [ "<NUMBER" ], "options": [] }:
	'[\p{L}\_\$][\p{L}\_\$0-9]*';
	
# Parser Fragments

fragment operator:
	BITWISE_OPERATOR | LOGIC_OPERATOR | COMPARISON_OPERATOR | MATH_OPERATOR | ASSIGNMENT_OPERATOR;

# Parser Rules
