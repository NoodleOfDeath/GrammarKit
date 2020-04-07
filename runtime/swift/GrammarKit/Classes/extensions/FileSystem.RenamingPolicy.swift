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

extension FileSystem {

    /// Simple data structure representing a renaming policy.
    struct RenamingPolicy {
        
        typealias This = RenamingPolicy
        
        struct Option: OptionSet {
            
            typealias RawValue = UInt
            
            let rawValue: UInt
            
            static let versionBeforeBasename = Option(1 << 0)
            static let versionAfterExtension = Option(1 << 1)
            
            static let versionDashed = Option(1 << 2)
            static let versionInsideParentheses = Option(1 << 3)
            static let versionInsideBraces = Option(1 << 4)
            static let versionInsideBrackets = Option(1 << 5)
            
            static let versionAsString = Option(1 << 6)
            
            init(_ rawValue: RawValue) {
                self.rawValue = rawValue
            }
            
            init(rawValue: RawValue) {
                self.rawValue = rawValue
            }
            
        }
        
        /// Automatic format policy.
        static let automatic = This(options: [.versionDashed], maximumAllowedRenamingAttempts: 99)
        
        /// Input regular expression format of this renaming policy.
        let inputFormat: String
        
        /// Output regular expression format of this renaming policy.
        let outputFormat: String
        
        /// Options of this renaming policy.
        let options: Option
        
        /// Number of times this policy allows the file system to rename
        /// a file.
        let maximumAllowedRenamingAttempts: Int
        
        // MARK: - Constructor Methods
        
        /// Constructs a new renaming policy instance set to `.automatic`.
        init() {
            self = .automatic
        }
        
        /// Constructs a new renaming policy with an initial format string.
        ///
        /// - Parameters:
        ///     - format: to use for this renaming policy.
        init(options: Option, maximumAllowedRenamingAttempts: Int = .max) {
            self.options = options
            inputFormat = "(\\w+)(?:\\.(\\w+))?$"
            var format = ""
            let versionTemplate = options.contains(.versionAsString) ? "%@" : "%d"
            if options.contains(.versionInsideParentheses) {
                format = String(format: "\\{%@\\}", versionTemplate)
            } else if options.contains(.versionInsideBraces) {
                format = String(format: "\\{%@\\}", versionTemplate)
            } else if options.contains(.versionInsideBrackets) {
                format = String(format: "\\[%@\\]", versionTemplate)
            } else {
                format = versionTemplate
            }
            if options.contains(.versionBeforeBasename) {
                if options.contains(.versionDashed) {
                    format = format + "-"
                }
                format = format + "$1\\.$2"
            } else if options.contains(.versionAfterExtension) {
                format = "$1\\.$2." + format
            } else {
                if options.contains(.versionDashed) {
                    format = "$1-" + format + "\\.$2"
                } else {
                    format = "$1" + format + "\\.$2"
                }
            }
            outputFormat = format
            self.maximumAllowedRenamingAttempts = maximumAllowedRenamingAttempts
        }
        
        // MARK: - Instance Methods
        
        /// Contructs a new renaming policy from this existing policy.
        func with(options: Option? = nil, maximumAllowedRenamingAttempts: Int) -> This {
            return This(options: options ?? self.options,
                        maximumAllowedRenamingAttempts: maximumAllowedRenamingAttempts)
        }
        
        /// Generates a newly formatted name from a basename and specified
        /// version number.
        ///
        /// - Parameters:
        ///     - path: of the item to rename.
        ///     - version: of the item to include in the generated name.
        ///     - condition: block of code that tells this policy to stop
        /// generating upon returning true.
        /// - Returns: a newly formatted name from a basename by replacing
        /// occurences of `inputFormat` in `basename` with `outputFormat` and
        /// using the resultant string as the string format, which takes a
        /// single numeric `CVarArg` argument representing the version number
        /// of the file.
        func generateVersionedFilename(from path: String, version: Int = 0, while condition: (_ name: String) -> Bool) -> String {
            let basename = path.lastPathComponent
            let format =
                basename.replacingOccurrences(of: inputFormat,
                                              with: outputFormat,
                                              options: .regularExpression,
                                              range: basename.range)
            var version = version
            var n = 0
            var newName = path.deletingLastPathComponent +/ basename
            while !condition(newName) && n < maximumAllowedRenamingAttempts {
                version += 1
                n += 1
                newName = path.deletingLastPathComponent +/ String(format: format, version)
            }
            return newName
        }
        
    }

}
