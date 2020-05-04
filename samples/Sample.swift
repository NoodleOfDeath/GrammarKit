//
// The MIT License (MIT)
//
// Copyright © 2020 NoodleOfDeath. All rights reserved.
// NoodleOfDeath
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

/// Base abstract class for a grammar matching.
public final class BaseGrammaticalMatcher: NSObject, GrammaticalMatcher {

    /// Delegate of this grammar matcher.
    open weak var delegate: GrammaticalMatcherDelegate?
    
    /// Grammar of this matcher.
    public let grammar: Grammar
    
    /// Constructs a new grammar matcher with an initial grammar.
    ///
    /// - Parameters:
    ///     - grammar: to initialize this matcher with.
    public init(grammar: Grammar, opts: GrammaticalMatcherOption = []) {
        self.grammar = grammar
        self.options = options
    }
    
}