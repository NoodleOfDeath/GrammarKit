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

import Foundation

extension GrammarLoader {

    /// Regular expression patterns used to parse grammar rules from string
    /// definitions.
    public struct Pattern {

        public static var patterns: [String: String] = {
            var patterns = [String: String]()
            if let patternFile = Bundle(for: Grammar.self).path(forResource: "patterns", ofType: "txt"),
                let contents = (try? String(contentsOfFile: patternFile))?.replacingOccurrences(of: "(//|#).*/\\*.*?\\*/", with: "", options: .regularExpression) {
                "(\\w+)\\s*=\\s*(.*)\\r?\\n".enumerateMatches(in: contents) { (match, _, _) in
                    guard let match = match else { return }
                    let key = contents.substring(with: match.range(at: 1))
                    let pattern = contents.substring(with: match.range(at: 2))
                    patterns[key] = pattern
                }
            }
            for (key, pattern) in patterns {
                var pattern = pattern
                var match = "\\\\\\((\\w+)\\)".firstMatch(in: pattern)
                while match != nil {
                    let id = pattern.substring(with: match!.range(at: 1))
                    guard let subpattern = patterns[id] else { continue }
                    pattern = (pattern as NSString).replacingCharacters(in: match!.range, with: subpattern)
                    match = "\\\\\\((\\w+)\\)".firstMatch(in: pattern)
                }
                patterns[key] = pattern
            }
            return patterns
        }()

        public static subscript(key: String) -> String? {
            return patterns[key]
        }
        
    }

}
