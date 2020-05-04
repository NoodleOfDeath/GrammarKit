grammar public.swift-source;
import public.source-code;

// Lexer Rule Fragments

fragment OPTIONAL_WRAPPER:
	'\?';
fragment STRICT_WRAPPER:
	'\!';

fragment ONE_LINE_DOCUMENTATION:
	'\/\/\/.*';
fragment ONE_LINE_COMMENT:
	'\/\/.*';

fragment MULTILINE_DOCUMENTATION:
	'\/\*(?s:.*?)(\*\/|\Z)';
fragment MULTILINE_COMMENT:
	'\/\*(?s:.*?)(\*\/|\Z)';

// Lexer Rules

DOCUMENTATION_BLOCK { "precedence": [ "<WHITESPACE", ">STRING" ], "options": [ "" ] }:
	((ONE_LINE_DOCUMENTATION | MULTILINE_DOCUMENTATION) (WHITESPACE | NEWLINE)*)+;

COMMENT_BLOCK { "precedence": [ "<DOCUMENTATION_BLOCK", ">STRING" ], "options": [ "" ] }:
	((ONE_LINE_COMMENT | MULTILINE_COMMENT) (WHITESPACE | NEWLINE)*)+;

NIL_COALESCING_OPERATOR { "precedence": [ "=OPERATOR" ], "options": [] }:
	'\?\?';
    
NIL_WRAPPER_POSTFIX { "precedence": [ "<NIL_COALESCING_OPERATOR" ], "options": [] }:
	OPTIONAL_WRAPPER | STRICT_WRAPPER;

RETURN_OPERATOR { "precedence": [ "<STRING", ">GT_OPERATOR", ">SUB_OPERATOR" ], "options": [] }:
	'\->';

RANGE_OPERATOR { "precedence": [ "<STRING", ">LT_OPERATOR" ], "options": [] }:
    '\.\.[.<]';

EXTENDED_ID { "precedence": [ ">ID", ">KEYWORD" ], "options": [] }:
	(('self' | ID) '\.')+ ID;

ANNOTATION { "precedence": [ ">ID", ">KEYWORD" ], "options": [] }:
	'@[\p{L}]+' (L_PAREN (STRING COMMA)* STRING R_PAREN)?;
		
KEYWORD { "precedence": [ "<TOKEN", "<OPERATOR", "<NUMBER" ], "options": [ "dictionary" ] }:
[
    { "id" : "#available" },
    { "id" : "#colorLiteral" },
    { "id" : "#column" },
    { "id" : "#else" },
    { "id" : "#elseif" },
    { "id" : "#endif" },
    { "id" : "#error" },
    { "id" : "#fileLiteral" },
    { "id" : "#file" },
    { "id" : "#function" },
    { "id" : "#if" },
    { "id" : "#imageLiteral" },
    { "id" : "#line" },
    { "id" : "#selector" },
    { "id" : "#sourceLocation" },
    { "id" : "#warning" },
    {
        "id" : "associatedtype",
        "description" : "When defining a protocol, it’s sometimes useful to declare one or more associated types as part of the protocol’s definition. An associated type gives a placeholder name to a type that is used as part of the protocol. The actual type to use for that associated type isn’t specified until the protocol is adopted. Associated types are specified with the associatedtype keyword.",
        "references" : [
            "https:\/\/docs.swift.org\/swift-book\/LanguageGuide\/Generics.html#ID189",
        ],
    },
    { "id" : "as" },
    { "id" : "Any" },
    { "id" : "break" },
    { "id" : "case" },
    { "id" : "catch" },
    { "id" : "class" },
    { "id" : "continue" },
    { "id" : "default" },
    { "id" : "defer" },
    { "id" : "deinit" },
    { "id" : "didSet" },
    { "id" : "do" },
    { "id" : "dynamic" },
    { "id" : "else" },
    { "id" : "enum" },
    { "id" : "extension" },
    { "id" : "fallthrough" },
    { "id" : "false" },
    { "id" : "fileprivate" },
    { "id" : "final" },
    { "id" : "for" },
    { "id" : "func" },
    { "id" : "get" },
    { "id" : "guard" },
    { "id" : "if" },
    { "id" : "import" },
    { "id" : "indirect" },
    { "id" : "infix" },
    { "id" : "init" },
    { "id" : "inout" },
    { "id" : "internal" },
    { "id" : "in" },
    { "id" : "is" },
    { "id" : "lazy" },
    { "id" : "left" },
    { "id" : "let" },
    { "id" : "mutating" },
    { "id" : "nil" },
    { "id" : "none" },
    { "id" : "nonmutating" },
    { "id" : "open" },
    { "id" : "operator" },
    { "id" : "optional" },
    { "id" : "override" },
    { "id" : "postfix" },
    { "id" : "precedence" },
    { "id" : "prefix" },
    { "id" : "private" },
    { "id" : "protocol" },
    { "id" : "Protocol" },
    { "id" : "public" },
    { "id" : "repeat" },
    { "id" : "required" },
    { "id" : "rethrows" },
    { "id" : "return" },
    { "id" : "right" },
    { "id" : "self" },
    { "id" : "Self" },
    { "id" : "set" },
    { "id" : "static" },
    { "id" : "struct" },
    { "id" : "subscript" },
    { "id" : "super" },
    { "id" : "switch" },
    { "id" : "throws" },
    { "id" : "throw" },
    { "id" : "try" },
    { "id" : "true" },
    { "id" : "typealias" },
    { "id" : "Type" },
    { "id" : "unowned" },
    { "id" : "var" },
    { "id" : "weak" },
    { "id" : "where" },
    { "id" : "while" },
    { "id" : "willSet" },
];

// Parser Rule Fragments

fragment access_modifier:
	'fileprivate' | 'final' | 'lazy' | 'private' | 'open' | 'override' | 'public' | 'static' | 'weak';

fragment builtin_datatype:
	'Bool' | 'Double' | 'Float' | 'String' | 'Int' | 'Void' | 'class';

fragment builtin_value:
	'false' | 'nil' | 'true';

fragment variable_declaration_keyword:
	'let' | 'var';

fragment closure:
    tuple RETURN_OPERATOR tuple;

fragment datatype:
	(builtin_datatype | (L_PAREN closure R_PAREN) | EXTENDED_ID | ID) NIL_WRAPPER_POSTFIX?;

fragment datavalue:
	builtin_value | literal_array | literal_range | tuple | method_invocation | STRING | LITERAL_STRING | NUMBER | EXTENDED_ID | ID | KEYWORD;

fragment operator { "options": [ "extend" ] }:
	NIL_COALESCING_OPERATOR;

fragment type_extension:
	COLON datatype (COMMA datatype)*;

fragment variable_accessor:
	datavalue (COLON datatype)?;

fragment array_accessor:
	datavalue L_BRACK datavalue R_BRACK;

fragment lhs_assignment_clause:
	array_accessor | variable_accessor;

fragment rhs_assignment_clause:
	(EQ_ASSIGNMENT_OPERATOR | INCREMENTAL_ASSIGNMENT_OPERATOR) expression;

fragment simple_expression:
	(datavalue | datatype) (operator (datavalue | datatype))?;

fragment opened_expression:
	(closed_expression | simple_expression) typecast?;

fragment closed_expression:
	L_PAREN opened_expression R_PAREN;

fragment typecast:
	'as' NIL_WRAPPER_POSTFIX? datatype;

fragment for_loop_expression:
	(ID | tuple | UNDERSCORE) 'in' expression | expression;

fragment parameter:
	UNDERSCORE? ID COLON datatype rhs_assignment_clause?;

fragment parameters:
	parameter (COMMA parameter)*;

fragment argument:
	(ID COLON)? datavalue;

fragment arguments:
	argument (COMMA argument)*;

// Parser Rules

import_statement { "precedence": [ ">expression" ], "options": [] }:
	'import' (EXTENDED_ID | ID);

// Declarations

declaration { "precedence": [ ">expression" ], "options": [ "skip" ] };

enum_declaration { "precedence": [ "=declaration" ], "options": [] }:
	(ANNOTATION | DOCUMENTATION_BLOCK)* access_modifier* 'enum' ID type_extension? BLOCK;

struct_declaration { "precedence": [ "=declaration" ], "options": [] }:
	(ANNOTATION | DOCUMENTATION_BLOCK)* access_modifier* 'struct' ID type_extension? BLOCK;

protocol_declaration { "precedence": [ "=declaration" ], "options": [] }:
	(ANNOTATION | DOCUMENTATION_BLOCK)* access_modifier* 'protocol' ID type_extension? BLOCK;

class_declaration { "precedence": [ "=declaration" ], "options": [] }:
	(ANNOTATION | DOCUMENTATION_BLOCK)* access_modifier* 'class' ID type_extension? BLOCK;

extension_declaration { "precedence": [ "=declaration" ], "options": [] }:
	(ANNOTATION | DOCUMENTATION_BLOCK)* 'extension' ID type_extension? BLOCK;

constructor_declaration { "precedence": [ "=declaration" ], "options": [] }:
	(ANNOTATION | DOCUMENTATION_BLOCK)* access_modifier* 'init' L_PAREN parameters? R_PAREN BLOCK;

function_declaration { "precedence": [ "=declaration" ], "options": [] }:
	(ANNOTATION | DOCUMENTATION_BLOCK)* access_modifier* 'func' ID L_PAREN parameters? R_PAREN 'throws'? (RETURN_OPERATOR expression)? BLOCK;
		
variable_declaration { "precedence": [ "=declaration" ], "options": [] }:
    (ANNOTATION | DOCUMENTATION_BLOCK)* access_modifier* variable_declaration_keyword ID rhs_assignment_clause?;

// Logic Control Structures

if_block { "precedence": [ ">expression" ] }:
    'else'? 'if' expression BLOCK;

else_block { "precedence": [ ">expression" ] }:
    'else' BLOCK;

do_block { "precedence": [ ">expression" ] }:
    'do' BLOCK;

catch_block { "precedence": [ ">expression" ] }:
    'catch' (variable_declaration | expression)? BLOCK;

// Flow Control Structures

for_loop { "precedence": [ ">expression" ], "options": [] }:
	'for' for_loop_expression BLOCK;
    
while_loop { "precedence": [ "=for_loop" ], "options": [] }:
	'while' 'let'? expression BLOCK;

repeat_loop { "precedence": [ "=for_loop" ], "options": [] }:
	'repeat' BLOCK 'while' expression;

// Invocations

method_invocation { "precedence": [ ">expression" ], "options": [] }:
	(EXTENDED_ID | ID) L_PAREN arguments? R_PAREN;

assignment_clause { "precedence": [ ">expression" ], "options": [] }:
	lhs_assignment_clause rhs_assignment_clause;

// Data Structures

literal_array { "precedence" : [ ">expression" ] }:
    L_BRACK (variable_accessor (COMMA variable_accessor)*)? R_BRACK;

tuple { "precedence": [ ">expression" ] }:
    L_PAREN (variable_accessor (COMMA variable_accessor)*)? R_PAREN;

literal_range { "precedence" : [ ">expression" ] }:
    NUMBER RANGE_OPERATOR NUMBER;

expression { "options": [] }:
	opened_expression (operator opened_expression)*;
