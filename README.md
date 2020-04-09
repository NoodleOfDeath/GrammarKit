# GrammarKit

[![CI Status](https://img.shields.io/travis/NoodleOfDeath/GrammarKit.svg?style=flat)](https://travis-ci.org/NoodleOfDeath/GrammarKit)
[![Version](https://img.shields.io/cocoapods/v/GrammarKit.svg?style=flat)](https://cocoapods.org/pods/GrammarKit)
[![License](https://img.shields.io/cocoapods/l/GrammarKit.svg?style=flat)](https://cocoapods.org/pods/GrammarKit)
[![Platform](https://img.shields.io/cocoapods/p/GrammarKit.svg?style=flat)](https://cocoapods.org/pods/GrammarKit)

The goal of GrammarKit is to provide a lightweight and extensible framework and matcher for grammatically matching (or the act of tokenizing and subsequently parsing) a stream of characters using a user defined grammar definition that can attribute meaning to occurrences and/or sequences of characters that match any number of custom rules belonging to that grammar. Using this framework should allow developers to not only define any number of custom languages _without the need for a complete project rebuild_ (just the addition of a simple XML file and/or ParserParser grammar package with the `.grammar` extension) but also use this matcher to apply syntax highlighting, identifier and scope recognition, and code recommendation/autocompletion in their applications.

Support to import and convert [ANTLR4](https://github.com/antlr/antlr4) `.g4` grammar files to GrammarKit grammar bundle format is a long term goal of this project, as well.

## General Workflow

The workflow of GrammarKit is meant to be easily integrated into development projects as an extensible microservice and not a massive blackboxed framework.

-- TODO --

## Authors and Major Contributors

-- TODO --

## Useful Documents

* [Release Notes](https://github.com/NoodleOfDeath/GrammarKit/release)
* [Getting Started](https://github.com/NoodleOfDeath/GrammarKit/blob/master/doc/getting-started.md)
* [Documentation](https://github.com/NoodleOfDeath/GrammarKit/blob/master/doc/README.md)

