grammar com.sun.java-source;
import public.source-code;

# Lexer Rule Fragments

fragment ONE_LINE_DOCUMENTATION:
    '\/\/\/.*';
fragment ONE_LINE_COMMENT:
    '\/\/.*';

fragment MULTILINE_DOCUMENTATION:
    '\/\*(?s:.*?)(\*\/|\Z)';
fragment MULTILINE_COMMENT:
    '\/\*(?s:.*?)(\*\/|\Z)';

# Lexer Rules

DOCUMENTATION_BLOCK { "precedence": [ "<WHITESPACE", ">STRING" ], "options": [ "" ] }:
    ((ONE_LINE_DOCUMENTATION | MULTILINE_DOCUMENTATION) (WHITESPACE | NEWLINE)*)+;

COMMENT_BLOCK { "precedence": [ "<DOCUMENTATION_BLOCK", ">STRING" ], "options": [ "" ] }:
    ((ONE_LINE_COMMENT | MULTILINE_COMMENT) (WHITESPACE | NEWLINE)*)+;

EXTENDED_ID { "precedence": [ ">ID", ">KEYWORD" ], "options": [] }:
    (('self' | ID) '\.')+ ID;

ANNOTATION { "precedence": [ ">ID", ">KEYWORD" ], "options": [] }:
    '@[\p{L}]+' (L_PAREN (STRING COMMA)* STRING R_PAREN)?;

KEYWORD { "precedence": [ "<TOKEN", "<OPERATOR", "<NUMBER" ], "options": [ "dictionary" ] }:
[
    { "id" : "abstract" },
    { "id" : "assert" },
    { "id" : "boolean" },
    { "id" : "break" },
    { "id" : "byte" },
    { "id" : "case" },
    { "id" : "catch" },
    { "id" : "char" },
    { "id" : "class" },
    { "id" : "const" },
    { "id" : "continue" },
    { "id" : "default" },
    { "id" : "double" },
    { "id" : "do" },
    { "id" : "else" },
    { "id" : "enum" },
    { "id" : "extends" },
    { "id" : "final" },
    { "id" : "finally" },
    { "id" : "float" },
    { "id" : "for" },
    { "id" : "goto" },
    { "id" : "if" },
    { "id" : "implements" },
    { "id" : "import" },
    { "id" : "instanceof" },
    { "id" : "interface" },
    { "id" : "int" },
    { "id" : "long" },
    { "id" : "native" },
    { "id" : "new" },
    { "id" : "null" },
    { "id" : "package" },
    { "id" : "private" },
    { "id" : "protected" },
    { "id" : "public" },
    { "id" : "return" },
    { "id" : "short" },
    { "id" : "static" },
    { "id" : "strictfp" },
    { "id" : "super" },
    { "id" : "switch" },
    { "id" : "synchronized" },
    { "id" : "this" },
    { "id" : "throws" },
    { "id" : "throw" },
    { "id" : "transient" },
    { "id" : "try" },
    { "id" : "void" },
    { "id" : "volatile" },
    { "id" : "while" },
];

# Parser Rule Fragments

# Parser Rules

package_declaration:
    'package' (EXTENDED_ID | ID) COLON;

