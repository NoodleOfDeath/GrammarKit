//
// The MIT License (MIT)
//
// Copyright © 2019 NoodleOfDeath. All rights reserved.
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

import MobileCoreServices

// MARK: - Additional Global `CFString` kUTType Constants

public let kUTTypeActionScript: CFString 
    = "com.adobe.actionscript.script" as CFString
public let kUTTypeCSS: CFString = "public.css" as CFString
public let kUTTypeHTACCESS: CFString = "public.htaccess" as CFString
public let kUTTypeMarkdown: CFString = "net.daringfireball.markdown" as CFString

public let kUTTypeSwiftSource: CFString = "public.swift-source" as CFString
public let kUTTypeYAML: CFString = "public.yaml" as CFString

public let kUTTypeUnknown: CFString = "public.unknown" as CFString

// MARK: - Protocols

/// Specifications for a object from which a uttype can be derived.
public protocol UTTypePathExtensionProtocol {
    
    /// Path extension of this object.
    var pathExtension: String { get }
    
}

public protocol UTTypeProtocol {
    
    /// Uniform type identifier of this object.
    var uttype: UTType { get }
    
}

extension NSString: UTTypePathExtensionProtocol {}
extension URL: UTTypePathExtensionProtocol {}

extension String: UTTypeProtocol {
    
    public var uttype: UTType {
        return ns.uttypeFromPathExtension
    }
    
}

extension URL: UTTypeProtocol {
    
    public var uttype: UTType {
        return uttypeFromPathExtension
    }
    
}

extension UTTypePathExtensionProtocol {
    
    /// Uniform type identifier of this object.
    public var uttypeFromPathExtension: UTType {
        let ext =
            pathExtension.replacingOccurrences(of: "^\\.*", with: "",
                                               options: .regularExpression,
                                               range: pathExtension.range)
        guard let fileType =
            UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension,
                                                  ext as CFString, nil)
            else { return .Unknown }
        return UTType(fileType.takeRetainedValue())
    }
    
}

extension UTTypeProtocol {
    
    /// Returns whether or not the uniform type identifier of this object
    /// conforms to a set of other uniform type identifiers.
    ///
    /// Overload for `conforms(to:mustConformToAll:)`.
    ///
    /// - Parameters:
    ///     - uttypes: to compare for conformance.
    ///     - mustConformToAll: specify `false` if this method should return
    /// `true` when the uniform type identifier of this object conforms to any  
    /// uniform type identifier specified in `uttypes`; specify `true`, if this
    /// method should return `true` only when the uniform type identifier
    /// of this object conforms to _all_ uniform type identifiers specified in
    /// `uttypes`. Default value is `false`.
    /// - Returns: `true` when the uniform type identifier of this object
    /// conforms to any uniform type identifier specified in `uttypes` and 
    /// `mustConformToAll` is `false`, or when the uniform type 
    /// identifer of this object conforms to _all_ uniform type identifiers 
    /// specified in `uttypes` and `mustConformToAll` is `true`; returns 
    /// `false`, otherwise.
    public func conforms(to uttypes: UTType..., 
        mustConformToAll: Bool = false) -> Bool {
        return conforms(to: uttypes, mustConformToAll: mustConformToAll)
    }
    
    /// Returns the first uniform type identifier from a set of uniform type 
    /// identifers that the uniform type identifier of this object conforms to, 
    /// or `nil` if the uniform type identifier of this object conforms to none  
    /// of the uniform type identifiers specified.
    ///
    /// Overload for `conforms(toFirst: [UTType]) -> UTType?`.
    ///
    /// - Parameters:
    ///     - uttypes: to compare for conformance.
    /// - Returns: the first uniform type identifier from `uttypes` that the
    /// uniform type identifer of this object conforms to, or `nil` if the
    /// uniform type identifier of this object conforms to none of the uniform 
    /// type identifiers specified in `uttypes`.
    public func conforms(toFirst uttypes: UTType...) -> UTType? {
        return uttype.conforms(toFirst: uttypes)
    }
    
    /// Returns whether or not the uniform type identifier of this object
    /// conforms to a set of other uniform type identifiers.
    ///
    /// - Parameters:
    ///     - uttypes: to compare for conformance.
    ///     - mustConformToAll: specify `false` if this method should return
    /// `true` when the uniform type identifier of this object conforms to any  
    /// uniform type identifier specified in `uttypes`; specify `true`, if this
    /// method should return `true` only when the uniform type identifier
    /// of this object conforms to _all_ uniform type identifiers specified in
    /// `uttypes`. Default value is `false`.
    /// - Returns: `true` when the uniform type identifier of this object
    /// conforms to any uniform type identifier specified in `uttypes` and 
    /// `mustConformToAll` is `false`, or when the uniform type 
    /// identifer of this object conforms to _all_ uniform type identifiers 
    /// specified in `uttypes` and `mustConformToAll` is `true`; returns 
    /// `false`, otherwise.
    public func conforms(to uttypes: [UTType],
                         mustConformToAll: Bool = false) -> Bool {
        return uttype.conforms(to: uttypes, mustConformToAll: mustConformToAll)
    }
    
    /// Returns the first uniform type identifier from a set of uniform type 
    /// identifers that the uniform type identifier of this object conforms to, 
    /// or `nil` if the uniform type identifier of this object conforms to none  
    /// of the uniform type identifiers specified.
    ///
    /// - Parameters:
    ///     - uttypes: to compare for conformance.
    /// - Returns: the first uniform type identifier from `uttypes` that the
    /// uniform type identifer of this object conforms to, or `nil` if the
    /// uniform type identifier of this object conforms to none of the uniform 
    /// type identifiers specified in `uttypes`.
    public func conforms(toFirst uttypes: [UTType]) -> UTType? {
        return uttype.conforms(toFirst: uttypes)
    }
    
}

/// A bridging data structure that converts all `CFString` constants that match
/// the regular expression `"kUTType\w+"` and modularizes them into a `UTType`
/// class constant.
///
/// **Example:** `kUTTypeBMP` is modularized to `UTType.BMP`.
public struct UTType: Hashable, Equatable, RawRepresentable {
    
    // MARK: - Typealiases
    
    public typealias RawValue = String
    public typealias CoreValue = CFString
    
    // MARK: - Static Properties
    
    /// Default raw value for new uniform type identifier instances.
    public static let DefaultRawValue = kUTTypeUnknown as RawValue
    
    /// Default core value for new uniform type identifier instances.
    public static let DefaultCoreValue: CoreValue = kUTTypeUnknown
    
    /// Unknown uniform type identifier.
    public static let Unknown = UTType(kUTTypeUnknown)
    
    // MARK: - RawRepresentable Properties
    
    public let rawValue: RawValue
    
    // MARK - Hashable Properties
    
    public var hashValue: Int { return rawValue.hashValue }
    
    // MARK: - Instance Properties
    
    /// `CFString` representation of this uniform type idenitifer.
    public var coreValue: CoreValue { return rawValue as CoreValue }
    
    /// `true` if `coreValue == kUTTypeUnknown`; `false` otherwise.
    public var isUnknown: Bool { return coreValue == kUTTypeUnknown }
    
    /// `true` if `coreValue != kUTTypeUnknown`; `false` otherwise.
    public var isNotUnknown: Bool { return coreValue != kUTTypeUnknown }
    
    // MARK: - Constructor Methods
    
    /// Constructs a new uniform type identifier instance with an initial 
    /// raw value.
    ///
    /// - Parameters:
    ///     - rawValue: to initialize this uniform type identifier with.
    public init(rawValue: RawValue) {
        self.rawValue = rawValue.starts(with: "dyn.") ? 
            kUTTypeItem as RawValue : rawValue
    }
    
    /// Constructs a new uniform type identifier instance with an initial 
    /// raw value.
    ///
    /// - Parameters:
    ///     - rawValue: to initialize this uniform type identifier with.
    public init(_ rawValue: RawValue) {
        self.rawValue = rawValue.starts(with: "dyn.") ? 
            kUTTypeItem as RawValue : rawValue
    }
    
    /// Constructs a new uniform type identifier instance with an initial core 
    /// value.
    ///
    /// - Parameters:
    ///     - coreValue: to initialize this uniform type identifier with.
    public init(coreValue: CoreValue) {
        rawValue = coreValue as RawValue
    }
    
    /// Constructs a new uniform type identifier instance with an initial core 
    /// value.
    ///
    /// - Parameters:
    ///     - coreValue: to initialize this uniform type identifier with.
    public init(_ coreValue: CoreValue) {
        rawValue = coreValue as RawValue
    }
    
    // MARK: - Equatable Methods
    
    public static func == (lhs: UTType, rhs: UTType) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
    
    public static func == (lhs: UTType?, rhs: UTType) -> Bool {
        return lhs?.rawValue == rhs.rawValue
    }
    
    public static func == (lhs: UTType, rhs: UTType?) -> Bool {
        return lhs.rawValue == rhs?.rawValue
    }
    
    public static func != (lhs: UTType, rhs: UTType) -> Bool {
        return lhs.rawValue != rhs.rawValue
    }
    
    public static func != (lhs: UTType?, rhs: UTType) -> Bool {
        return lhs?.rawValue != rhs.rawValue
    }
    
    public static func != (lhs: UTType, rhs: UTType?) -> Bool {
        return lhs.rawValue != rhs?.rawValue
    }
    
    // MARK: - Instance Methods
    
    /// Returns whether or not this uniform type identifier conforms to a set of
    /// other uniform type identifiers.
    ///
    /// Overload for 
    /// `conforms(to: [UTType], mustConformToAll: Bool)`.
    ///
    /// - Parameters:
    ///     - uttypes: to compare for conformance.
    ///     - mustConformToAll: specify `false` if this method should return
    /// `true` when this uniform type identifier conforms to any uniform type
    /// identifier specified in `uttypes`; specify `true`, if this method
    /// should only return `true` when this uniform type identifier conforms 
    /// to _all_ uniform type identifiers specified in `uttypes`. Default value 
    /// is `false`.
    /// - Returns: `true` when this uniform type identifier conforms to any
    /// uniform type identifier specified in `uttypes` and `mustConformToAll` is
    /// `false`, or when this uniform type identifier conforms to _all_
    /// uniform type identifiers specified in `uttypes` and `mustConformToAll` 
    /// is `true`; returns `false`, otherwise.
    public func conforms(to uttypes: UTType..., 
        mustConformToAll: Bool = false) -> Bool {
        return conforms(to: uttypes, 
                        mustConformToAll: mustConformToAll)
    }
    
    /// Returns the first uniform type identifier from a set of uniform type 
    /// identifers that this uniform type identifier conforms to, or `nil` if 
    /// this uniform type identifier conforms to none of the uniform type 
    /// identifiers specified.
    ///
    /// Overload for `conforms(toFirst: [UTType]) -> UTType?`.
    ///
    /// - Parameters:
    ///     - uttypes: to compare for conformance.
    /// - Returns: the first uniform type identifier from `uttypes` that this
    /// uniform type identifer conforms to, or `nil` if this uniform type
    /// identifier conforms to none of the uniform type identifiers specified
    /// in `uttypes`.
    public func conforms(toFirst uttypes: UTType...) -> UTType? {
        return conforms(toFirst: uttypes)
    }
    
    /// Returns whether or not this uniform type identifier conforms to a set of
    /// other uniform type identifiers.
    ///
    /// - Parameters:
    ///     - uttypes: to compare for conformance.
    ///     - mustConformToAll: specify `false` if this method should return
    /// `true` when this uniform type identifier conforms to any uniform type
    /// identifier specified in `uttypes`; specify `true`, if this method
    /// should only return `true` when this uniform type identifier conforms 
    /// to _all_ uniform type identifiers specified in `uttypes`. Default value 
    /// is `true`.
    /// - Returns: `true` when this uniform type identifier conforms to any
    /// uniform type identifier specified in `uttypes` and `mustConformToAll` is
    /// `false`, or when this uniform type identifier conforms to _all_
    /// uniform type identifiers specified in `uttypes` and `mustConformToAll` 
    /// is `true`; returns `false`, otherwise.
    public func conforms(to uttypes: [UTType], 
                         mustConformToAll: Bool = false) -> Bool {
        if uttypes.count < 1 { return false }
        if uttypes.count == 1 {
            return UTTypeConformsTo(coreValue, uttypes[0].coreValue)
        }
        for uttype in uttypes {
            if !mustConformToAll && 
                UTTypeConformsTo(coreValue, uttype.coreValue) { return true }
            if mustConformToAll && 
                !UTTypeConformsTo(coreValue, uttype.coreValue) { return false }
        }
        return true
    }
    
    /// Returns the first uniform type identifier from a set of uniform type 
    /// identifers that this uniform type identifier conforms to, or `nil` if 
    /// this uniform type identifier conforms to none of the uniform type 
    /// identifiers specified.
    ///
    /// - Parameters:
    ///     - uttypes: to compare for conformance.
    /// - Returns: the first uniform type identifier from `uttypes` that this
    /// uniform type identifer conforms to, or `nil` if this uniform type
    /// identifier conforms to none of the uniform type identifiers specified
    /// in `uttypes`.
    public func conforms(toFirst uttypes: [UTType]) -> UTType? {
        if uttypes.count < 1 { return nil }
        if uttypes.count == 1 {
            return UTTypeConformsTo(coreValue, uttypes[0].coreValue) ? uttypes[0] : nil
        }
        for uttype in uttypes {
            if UTTypeConformsTo(coreValue, uttype.coreValue) { return uttype }
        }
        return nil
    }
    
}

// MARK: - CustomStringConvertible Properties
extension UTType: CustomStringConvertible {
    
    public var description: String {
        return rawValue
    }
    
}

// MARK: - CVarArg Properties
extension UTType: CVarArg {
    
    public var _cVarArgEncoding: [Int] {
        return description._cVarArgEncoding
    }
    
}

// MARK: - Enumerated Static Values
extension UTType {
    
    /*
     *  kUTTypeItem
     *
     *    generic base type for most things
     *    (files, directories)
     *
     *    UTI: public.item
     *
     *
     *  kUTTypeContent
     *
     *    base type for anything containing user-viewable document content
     *    (documents, pasteboard data, and document packages)
     *
     *    UTI: public.content
     *
     *
     *  kUTTypeCompositeContent
     *
     *    base type for content formats supporting mixed embedded content
     *    (i.e., compound documents)
     *
     *    UTI: public.composite-content
     *    conform/// to: public.content
     *
     *
     *  kUTTypeMessage
     *
     *    base type for messages (email, IM, etc.)
     *
     *    UTI: public.message
     *
     *
     *  kUTTypeContact
     *
     *    contact information, e.g. for a person, group, organization
     *
     *    UTI: public.contact
     *
     *
     *  kUTTypeArchive
     *
     *    an archive of files and directories
     *
     *    UTI: public.archive
     *
     *
     *  kUTTypeDiskImage
     *
     *    a data item mountable as a volume
     *
     *    UTI: public.disk-image
     *
     */
    @available(iOS 3.0, *)
    public static let Item = UTType(kUTTypeItem)
    @available(iOS 3.0, *)
    public static let Content = UTType(kUTTypeContent)
    @available(iOS 3.0, *)
    public static let CompositeContent = UTType(kUTTypeCompositeContent)
    @available(iOS 3.0, *)
    public static let Message = UTType(kUTTypeMessage)
    @available(iOS 3.0, *)
    public static let Contact = UTType(kUTTypeContact)
    @available(iOS 3.0, *)
    public static let Archive = UTType(kUTTypeArchive)
    @available(iOS 3.0, *)
    public static let DiskImage = UTType(kUTTypeDiskImage)
    
    /*
     *  kUTTypeData
     *
     *    base type for any sort of simple byte stream,
     *    including files and in-memory data
     *
     *    UTI: public.data
     *    conform/// to: public.item
     *
     *
     *  kUTTypeDirectory
     *
     *    file system directory 
     *    (includes packages AND folders)
     *
     *    UTI: public.directory
     *    conform/// to: public.item
     *
     *
     *  kUTTypeResolvable
     *
     *    symlink and alias file types conform to this UTI
     *
     *    UTI: com.apple.resolvable
     *
     *
     *  kUTTypeSymLink
     *
     *    a symbolic link
     *
     *    UTI: public.symlink
     *    conform/// to: public.item, com.apple.resolvable
     *
     *
     *  kUTTypeExecutable
     *
     *    an executable item
     *    UTI: public.executable
     *    conform/// to: public.item
     *
     *
     *  kUTTypeMountPoint
     *
     *    a volume mount point (resolvable, resolves to the root dir of a volume)
     *
     *    UTI: com.apple.mount-point
     *    conform/// to: public.item, com.apple.resolvable
     *
     *
     *  kUTTypeAliasFile
     *
     *    a fully-formed alias file
     *
     *    UTI: com.apple.alias-file
     *    conform/// to: public.data, com.apple.resolvable
     *
     *
     *  kUTTypeAliasRecord
     *
     *    raw alias data
     *
     *    UTI: com.apple.alias-record
     *    conform/// to: public.data, com.apple.resolvable
     *
     *
     *  kUTTypeURLBookmarkData
     *
     *    URL bookmark
     *
     *    UTI: com.apple.bookmark
     *    conform/// to: public.data, com.apple.resolvable
     *
     */
    @available(iOS 3.0, *)
    public static let Data = UTType(kUTTypeData)
    @available(iOS 3.0, *)
    public static let Directory = UTType(kUTTypeDirectory)
    @available(iOS 3.0, *)
    public static let Resolvable = UTType(kUTTypeResolvable)
    @available(iOS 3.0, *)
    public static let SymLink = UTType(kUTTypeSymLink)
    @available(iOS 8.0, *)
    public static let Executable = UTType(kUTTypeExecutable)
    @available(iOS 3.0, *)
    public static let MountPoint = UTType(kUTTypeMountPoint)
    @available(iOS 3.0, *)
    public static let AliasFile = UTType(kUTTypeAliasFile)
    @available(iOS 3.0, *)
    public static let AliasRecord = UTType(kUTTypeAliasRecord)
    @available(iOS 8.0, *)
    public static let URLBookmarkData = UTType(kUTTypeURLBookmarkData)
    
    /*
     *  kUTTypeURL
     *
     *    The bytes of a URL
     *    (OSType 'url ')
     *
     *    UTI: public.url
     *    conform/// to: public.data
     *
     *
     *  kUTTypeFileURL
     *
     *    The text of a "file:" URL 
     *    (OSType 'furl')
     *
     *    UTI: public.file-url
     *    conform/// to: public.url
     *
     */
    @available(iOS 3.0, *)
    public static let URL = UTType(kUTTypeURL)
    @available(iOS 3.0, *)
    public static let FileURL = UTType(kUTTypeFileURL)
    
    /*
     *  kUTTypeText
     *
     *    base type for all text-encoded data, 
     *    including text with markup (HTML, RTF, etc.)
     *
     *    UTI: public.text
     *    conform/// to: public.data, public.content
     *
     *
     *  kUTTypePlainText
     *
     *    text with no markup, unspecified encoding
     *
     *    UTI: public.plain-text
     *    conform/// to: public.text
     *
     *
     *  kUTTypeUTF8PlainText
     *
     *    plain text, UTF-8 encoding
     *    (OSType 'utf8', NSPasteboardType "NSStringPBoardType")
     *
     *    UTI: public.utf8-plain-text
     *    conform/// to: public.plain-text
     *
     *
     *  kUTTypeUTF16ExternalPlainText
     *
     *    plain text, UTF-16 encoding, with BOM, or if BOM 
     *    is not present, has "external representation" 
     *    byte order (big-endian).
     *    (OSType 'ut16')
     *
     *    UTI: public.utf16-external-plain-text
     *    conform/// to: public.plain-text
     *
     *
     *  kUTTypeUTF16PlainText
     *
     *    plain text, UTF-16 encoding, native byte order, optional BOM
     *    (OSType 'utxt')
     *
     *    UTI: public.utf16-plain-text
     *    conform/// to: public.plain-text
     *
     *
     *  kUTTypeDelimitedText
     *
     *    text containing delimited values
     *
     *    UTI: public.delimited-values-text
     *    conform/// to: public.text
     *
     *
     *  kUTTypeCommaSeparatedText
     *
     *    text containing comma-separated values (.csv)
     *
     *    UTI: public.comma-separated-values-text
     *    conform/// to: public.delimited-values-text
     *
     *
     *  kUTTypeTabSeparatedText
     *
     *    text containing tab-separated values
     *
     *    UTI: public.tab-separated-values-text
     *    conform/// to: public.delimited-values-text
     *
     *
     *  kUTTypeUTF8TabSeparatedText
     *
     *    UTF-8 encoded text containing tab-separated values
     *
     *    UTI: public.utf8-tab-separated-values-text
     *    conform/// to: public.tab-/// eparated-values-text, public.utf8-plain-text
     *
     *
     *  kUTTypeRTF
     *
     *    Rich text EFat
     *
     *    UTI: public.rtf
     *    conform/// to: public.text
     *
     */
    @available(iOS 3.0, *)
    public static let Text = UTType(kUTTypeText)
    @available(iOS 3.0, *)
    public static let PlainText = UTType(kUTTypePlainText)
    @available(iOS 3.0, *)
    public static let UTF8PlainText = UTType(kUTTypeUTF8PlainText)
    @available(iOS 3.0, *)
    public static let UTF16ExternalPlainText 
        = UTType(kUTTypeUTF16ExternalPlainText)
    @available(iOS 3.0, *)
    public static let UTF16PlainText = UTType(kUTTypeUTF16PlainText)
    @available(iOS 8.0, *)
    public static let DelimitedText = UTType(kUTTypeDelimitedText)
    @available(iOS 8.0, *)
    public static let CommaSeparatedText = UTType(kUTTypeCommaSeparatedText)
    @available(iOS 8.0, *)
    public static let TabSeparatedText = UTType(kUTTypeTabSeparatedText)
    @available(iOS 8.0, *)
    public static let UTF8TabSeparatedText 
        = UTType(kUTTypeUTF8TabSeparatedText)
    @available(iOS 3.0, *)
    public static let RTF = UTType(kUTTypeRTF)
    
    /*
     *  kUTTypeHTML
     *
     *    HTML, any version
     *
     *    UTI: public.html
     *    conform/// to: public.text
     *
     *
     *  kUTTypeXML
     *
     *    generic XML
     *
     *    UTI: public.xml
     *    conform/// to: public.text
     *
     */
    @available(iOS 3.0, *)
    public static let HTML = UTType(kUTTypeHTML)
    @available(iOS 3.0, *)
    public static let XML = UTType(kUTTypeXML)
    
    /*
     *  kUTTypeSourceCode
     *
     *    abstract type for source code (any language)
     *
     *    UTI: public.source-code
     *    conform/// to: public.plain-text
     *
     *
     *  kUTTypeAssemblyLanguageSource
     *
     *    assembly language source (.s)
     *
     *    UTI: public.assembly-source
     *    conform/// to: public.source-code
     *
     *
     *  kUTTypeCSource
     *
     *    C source code (.c)
     *
     *    UTI: public.c-source
     *    conform/// to: public.source-code
     *
     *
     *  kUTTypeObjectiveCSource
     *
     *    Objective-C source code (.m)
     *
     *    UTI: public.objective-c-source
     *    conform/// to: public.source-code
     *
     *
     *  kUTTypeSwiftSource
     *
     *    Swift source code (.swift)
     *
     *    UTI: public.swift-source
     *    conform/// to: public.source-code
     *
     *
     *  kUTTypeCPlusPlusSource
     *
     *    C++ source code (.cp, etc.)
     *
     *    UTI: public.c-plus-plus-source
     *    conform/// to: public.source-code
     *
     *
     *  kUTTypeObjectiveCPlusPlusSource
     *
     *    Objective-C++ source code
     *
     *    UTI: public.objective-c-plus-plus-source
     *    conform/// to: public.source-code
     *
     *
     *  kUTTypeCHeader
     *
     *    C header
     *
     *    UTI: public.c-header
     *    conform/// to: public.source-code
     *
     *
     *  kUTTypeCPlusPlusHeader
     *
     *    C++ header
     *
     *    UTI: public.c-plus-plus-header
     *    conform/// to: public.source-code
     *
     *
     *  kUTTypeJavaSource
     *
     *    Java source code
     *
     *    UTI: com.sun.java-source
     *    conform/// to: public.source-code
     *
     */
    @available(iOS 3.0, *)
    public static let SourceCode = UTType(kUTTypeSourceCode)
    @available(iOS 8.0, *)
    public static let AssemblyLanguageSource 
        = UTType(kUTTypeAssemblyLanguageSource)
    @available(iOS 3.0, *)
    public static let CSource = UTType(kUTTypeCSource)
    @available(iOS 3.0, *)
    public static let ObjectiveCSource = UTType(kUTTypeObjectiveCSource)
    @available(iOS 8.0, *)
    public static let SwiftSource = UTType(kUTTypeSwiftSource)
    @available(iOS 3.0, *)
    public static let CPlusPlusSource = UTType(kUTTypeCPlusPlusSource)
    @available(iOS 3.0, *)
    public static let ObjectiveCPlusPlusSource 
        = UTType(kUTTypeObjectiveCPlusPlusSource)
    @available(iOS 3.0, *)
    public static let CHeader = UTType(kUTTypeCHeader)
    @available(iOS 3.0, *)
    public static let CPlusPlusHeader = UTType(kUTTypeCPlusPlusHeader)
    @available(iOS 3.0, *)
    public static let JavaSource = UTType(kUTTypeJavaSource)
    
    /*
     *  kUTTypeScript
     *
     *    scripting language source
     *
     *    UTI: public.script
     *    conform/// to: public.source-code
     *
     *
     *  kUTTypeAppleScript
     *
     *    AppleScript text format (.applescript)
     *
     *    UTI: com.apple.applescript.text
     *    conform/// to: public.script
     *
     *
     *  kUTTypeOSAScript
     *
     *    public Scripting Architecture script binary format (.scpt)
     *
     *    UTI: com.apple.applescript.script
     *    conform/// to: public.data, public.script
     *
     *
     *  kUTTypeOSAScriptBundle
     *
     *    public Scripting Architecture script bundle format (.scptd)
     *
     *    UTI: com.apple.applescript.script-bundle
     *    conform/// to: com.apple.bundle, com.apple.package, public.script
     *
     *
     *  kUTTypeJavaScript
     *
     *    JavaScript source code
     *
     *    UTI: com.netscape.javascript-source
     *    conform/// to: public./// ource-code, public.executable
     *
     *
     *  kUTTypeShellScript
     *
     *    base type for shell scripts
     *
     *    UTI: public.shell-script
     *    conform/// to: public.script
     *
     *
     *  kUTTypePerlScript
     *
     *    Perl script
     *
     *    UTI: public.perl-script
     *    conform/// to: public.shell-script
     *
     *
     *  kUTTypePythonScript
     *
     *    Python script
     *
     *    UTI: public.python-script
     *    conform/// to: public.shell-script
     *
     *
     *  kUTTypeRubyScript
     *
     *    Ruby script
     *
     *    UTI: public.ruby-script
     *    conform/// to: public.shell-script
     *
     *
     *  kUTTypePHPScript
     *
     *    PHP script
     *
     *    UTI: public.php-script
     *    conform/// to: public.shell-script
     *
     */
    @available(iOS 8.0, *)
    public static let Script = UTType(kUTTypeScript)
    @available(iOS 8.0, *)
    public static let AppleScript = UTType(kUTTypeAppleScript)
    @available(iOS 8.0, *)
    public static let OSAScript = UTType(kUTTypeOSAScript)
    @available(iOS 8.0, *)
    public static let OSAScriptBundle = UTType(kUTTypeOSAScriptBundle)
    @available(iOS 8.0, *)
    public static let JavaScript = UTType(kUTTypeJavaScript)
    @available(iOS 8.0, *)
    public static let ShellScript = UTType(kUTTypeShellScript)
    @available(iOS 8.0, *)
    public static let PerlScript = UTType(kUTTypePerlScript)
    @available(iOS 8.0, *)
    public static let PythonScript = UTType(kUTTypePythonScript)
    @available(iOS 8.0, *)
    public static let RubyScript = UTType(kUTTypeRubyScript)
    @available(iOS 8.0, *)
    public static let PHPScript = UTType(kUTTypePHPScript)
    
    /*
     *  kUTTypeJSON
     *
     *    JavaScript object notation (JSON) data
     *    NOTE: JSON almost but doesn't quite conform to
     *    com.netscape.javascript-source
     *
     *    UTI: public.json
     *    conform/// to: public.text
     *
     *
     *  kUTTypePropertyList
     *
     *    base type for property lists
     *
     *    UTI: com.apple.property-list
     *    conform/// to: public.data
     *
     *
     *  kUTTypeXMLPropertyList
     *
     *    XML property list
     *
     *    UTI: com.apple.xml-property-list
     *    conform/// to: public.xml, com.apple.property-list
     *
     *
     *  kUTTypeBinaryPropertyList
     *
     *    XML property list
     *
     *    UTI: com.apple.binary-property-list
     *    conforms to: com.apple.property-list
     *
     */
    @available(iOS 8.0, *)
    public static let JSON = UTType(kUTTypeJSON)
    @available(iOS 8.0, *)
    public static let PropertyList = UTType(kUTTypePropertyList)
    @available(iOS 8.0, *)
    public static let XMLPropertyList = UTType(kUTTypeXMLPropertyList)
    @available(iOS 8.0, *)
    public static let BinaryPropertyList = UTType(kUTTypeBinaryPropertyList)
    
    /*
     *  kUTTypePDF
     *
     *    Adobe PDF
     *
     *    UTI: com.adobe.pdf
     *    conform/// to: public.data, public.composite-content
     *
     *
     *  kUTTypeRTFD
     *
     *    Rich text EFat Directory 
     *    (RTF with content embedding, on-disk format)
     *
     *    UTI: com.apple.rtfd
     *    conform/// to: com.apple.package, public.composite-content
     *
     *
     *  kUTTypeFlatRTFD
     *
     *    Flattened RTFD (pasteboard format)
     *
     *    UTI: com.apple.flat-rtfd
     *    conform/// to: public.data, public.composite-content
     *
     *
     *  kUTTypeTXNTextAndMultimediaData
     *
     *    MLTE (Textension) format for mixed text & multimedia data
     *    (OSType 'txtn')
     *
     *    UTI: com.apple.txn.text-multimedia-data
     *    conform/// to: public.data, public.composite-content
     *
     *
     *  kUTTypeWebArchive
     *
     *    The WebKit webarchive format
     *
     *    UTI: com.apple.webarchive
     *    conform/// to: public.data, public.composite-content
     */
    @available(iOS 3.0, *)
    public static let PDF = UTType(kUTTypePDF)
    @available(iOS 3.0, *)
    public static let RTFD = UTType(kUTTypeRTFD)
    @available(iOS 3.0, *)
    public static let FlatRTFD = UTType(kUTTypeFlatRTFD)
    @available(iOS 3.0, *)
    public static let TXNTextAndMultimediaData 
        = UTType(kUTTypeTXNTextAndMultimediaData)
    @available(iOS 3.0, *)
    public static let WebArchive = UTType(kUTTypeWebArchive)
    
    /*
     *  kUTTypeImage
     *
     *    abstract image data
     *
     *    UTI: public.image
     *    conform/// to: public.data, public.content
     *
     *
     *  kUTTypeJPEG
     *
     *    JPEG image
     *
     *    UTI: public.jpeg
     *    conform/// to: public.image
     *
     *
     *  kUTTypeJPEG2000
     *
     *    JPEG-2000 image
     *
     *    UTI: public.jpeg-2000
     *    conform/// to: public.image
     *
     *
     *  kUTTypeTIFF
     *
     *    TIFF image
     *
     *    UTI: public.tiff
     *    conform/// to: public.image
     *
     *
     *  kUTTypePICT
     *
     *    Quickdraw PICT format
     *
     *    UTI: com.apple.pict
     *    conform/// to: public.image
     *
     *
     *  kUTTypeGIF
     *
     *    GIF image
     *
     *    UTI: com.compuserve.gif
     *    conform/// to: public.image
     *
     *
     *  kUTTypePNG
     *
     *    PNG image
     *
     *    UTI: public.png
     *    conform/// to: public.image
     *
     *
     *  kUTTypeQuickTimeImage
     *
     *    QuickTime image format (OSType 'qtif')
     *
     *    UTI: com.apple.quicktime-image
     *    conform/// to: public.image
     *
     *
     *  kUTTypeAppleICNS
     *
     *    Apple icon data
     *
     *    UTI: com.apple.icns
     *    conform/// to: public.image
     *
     *
     *  kUTTypeBMP
     *
     *    Windows bitmap
     *
     *    UTI: com.microsoft.bmp
     *    conform/// to: public.image
     *
     *
     *  kUTTypeICO
     *
     *    Windows icon data
     *
     *    UTI: com.microsoft.ico
     *    conform/// to: public.image
     *
     *
     *  kUTTypeRawImage
     *
     *    base type for raw image data (.raw)
     *
     *    UTI: public.camera-raw-image
     *    conform/// to: public.image
     *
     *
     *  kUTTypeScalableVectorGraphics
     *
     *    SVG image
     *
     *    UTI: public.svg-image
     *    conform/// to: public.image
     *
     *  kUTTypeLivePhoto
     *
     *    Live Photo
     *
     *    UTI: com.apple.live-photo
     *
     *
     */
    @available(iOS 3.0, *)
    public static let Image = UTType(kUTTypeImage)
    @available(iOS 3.0, *)
    public static let JPEG = UTType(kUTTypeJPEG)
    @available(iOS 3.0, *)
    public static let JPEG2000 = UTType(kUTTypeJPEG2000)
    @available(iOS 3.0, *)
    public static let TIFF = UTType(kUTTypeTIFF)
    @available(iOS 3.0, *)
    public static let PICT = UTType(kUTTypePICT)
    @available(iOS 3.0, *)
    public static let GIF = UTType(kUTTypeGIF)
    @available(iOS 3.0, *)
    public static let PNG = UTType(kUTTypePNG)
    @available(iOS 3.0, *)
    public static let QuickTimeImage = UTType(kUTTypeQuickTimeImage)
    @available(iOS 3.0, *)
    public static let AppleICNS = UTType(kUTTypeAppleICNS)
    @available(iOS 3.0, *)
    public static let BMP = UTType(kUTTypeBMP)
    @available(iOS 3.0, *)
    public static let ICO = UTType(kUTTypeICO)
    @available(iOS 8.0, *)
    public static let RawImage = UTType(kUTTypeRawImage)
    @available(iOS 8.0, *)
    public static let ScalableVectorGraphics 
        = UTType(kUTTypeScalableVectorGraphics)
    @available(iOS 9.1, *)
    public static let LivePhoto = UTType(kUTTypeLivePhoto)
    
    /*
     *  kUTTypeAudiovisualContent
     *
     *    audio and/or video content
     *
     *    UTI: public.audiovisual-content
     *    conform/// to: public.data, public.content
     *
     *
     *  kUTTypeMovie
     *
     *    A media format which may contain both video and audio
     *    Corresponds to what users would label a "movie"
     *
     *    UTI: public.movie
     *    conform/// to: public.audiovisual-content
     *
     *
     *  kUTTypeVideo
     *
     *    pure video (no audio)
     *
     *    UTI: public.video
     *    conform/// to: public.movie
     *
     *
     *  kUTTypeAudio
     *
     *    pure audio (no video)
     *
     *    UTI: public.audio
     *    conform/// to: public.audiovisual-content
     *
     *
     *  kUTTypeQuickTimeMovie
     *
     *    QuickTime movie
     *
     *    UTI: com.apple.quicktime-movie
     *    conform/// to: public.movie
     *
     *
     *  kUTTypeMPEG
     *
     *    MPEG-1 or MPEG-2 movie
     *
     *    UTI: public.mpeg
     *    conform/// to: public.movie
     *
     *
     *  kUTTypeMPEG2Video
     *
     *    MPEG-2 video
     *
     *    UTI: public.mpeg-2-video
     *    conform/// to: public.video
     *
     *
     *  kUTTypeMPEG2TransportStream
     *
     *    MPEG-2 Transport Stream movie format
     *
     *    UTI: public.mpeg-2-transport-stream
     *    conform/// to: public.movie
     *
     *
     *  kUTTypeMP3
     *
     *    MP3 audio
     *
     *    UTI: public.mp3
     *    conform/// to: public.audio
     *
     *
     *  kUTTypeMPEG4
     *
     *    MPEG-4 movie
     *
     *    UTI: public.mpeg-4
     *    conform/// to: public.movie
     *
     *
     *  kUTTypeMPEG4Audio
     *
     *    MPEG-4 audio layer
     *
     *    UTI: public.mpeg-4-audio
     *    conform/// to: public.mpeg-4, public.audio
     *
     *
     *  kUTTypeAppleProtectedMPEG4Audio
     *
     *    Apple protected MPEG4 format
     *    (.m4p, iTunes music store format)
     *
     *    UTI: com.apple.protected-mpeg-4-audio
     *    conform/// to: public.audio
     *
     *
     *  kUTTypeAppleProtectedMPEG4Video
     *
     *    Apple protected MPEG-4 movie
     *
     *    UTI: com.apple.protected-mpeg-4-video
     *    conforms to: com.apple.m4v-video
     *
     *
     *  kUTTypeAVIMovie
     *
     *    Audio Video Interleaved (AVI) movie format
     *
     *    UTI: public.avi
     *    conform/// to: public.movie
     *
     *
     *  kUTTypeAudioInterchangeFileFormat
     *
     *    AIFF audio format
     *
     *    UTI: public.aiff-audio
     *    conform/// to: public.aifc-audio
     *
     *
     *  kUTTypeWaveformAudio
     *
     *    Waveform audio format (.wav)
     *
     *    UTI: com.microsoft.waveform-audio
     *    conform/// to: public.audio
     *
     *
     *  kUTTypeMIDIAudio
     *
     *    MIDI audio format
     *
     *    UTI: public.midi-audio
     *    conform/// to: public.audio
     *
     *
     */
    @available(iOS 3.0, *)
    public static let AudiovisualContent = UTType(kUTTypeAudiovisualContent)
    @available(iOS 3.0, *)
    public static let Movie = UTType(kUTTypeMovie)
    @available(iOS 3.0, *)
    public static let Video = UTType(kUTTypeVideo)
    @available(iOS 3.0, *)
    public static let Audio = UTType(kUTTypeAudio)
    @available(iOS 3.0, *)
    public static let QuickTimeMovie = UTType(kUTTypeQuickTimeMovie)
    @available(iOS 3.0, *)
    public static let MPEG = UTType(kUTTypeMPEG)
    @available(iOS 8.0, *)
    public static let MPEG2Video = UTType(kUTTypeMPEG2Video)
    @available(iOS 8.0, *)
    public static let MPEG2TransportStream 
        = UTType(kUTTypeMPEG2TransportStream)
    @available(iOS 3.0, *)
    public static let MP3 = UTType(kUTTypeMP3)
    @available(iOS 3.0, *)
    public static let MPEG4 = UTType(kUTTypeMPEG4)
    @available(iOS 3.0, *)
    public static let MPEG4Audio = UTType(kUTTypeMPEG4Audio)
    @available(iOS 3.0, *)
    public static let AppleProtectedMPEG4Audio 
        = UTType(kUTTypeAppleProtectedMPEG4Audio)
    @available(iOS 8.0, *)
    public static let AppleProtectedMPEG4Video 
        = UTType(kUTTypeAppleProtectedMPEG4Video)
    @available(iOS 8.0, *)
    public static let AVIMovie = UTType(kUTTypeAVIMovie)
    @available(iOS 8.0, *)
    public static let AudioInterchangeFileFormat 
        = UTType(kUTTypeAudioInterchangeFileFormat)
    @available(iOS 8.0, *)
    public static let WaveformAudio = UTType(kUTTypeWaveformAudio)
    @available(iOS 8.0, *)
    public static let MIDIAudio = UTType(kUTTypeMIDIAudio)
    
    /*
     *  kUTTypePlaylist
     *
     *    base type for playlists
     *
     *    UTI: public.playlist
     *
     *
     *  kUTTypeM3UPlaylist
     *
     *    M3U or M3U8 playlist
     *
     *    UTI: public.m3u-playlist
     *    conform/// to: public.text, public.playlist
     *
     */
    @available(iOS 8.0, *)
    public static let Playlist = UTType(kUTTypePlaylist)
    @available(iOS 8.0, *)
    public static let M3UPlaylist = UTType(kUTTypeM3UPlaylist)
    
    /*
     *  kUTTypeFolder
     *
     *    a user-browsable directory (i.e., not a package)
     *
     *    UTI: public.folder
     *    conform/// to: public.directory
     *
     *
     *  kUTTypeVolume
     *
     *    the root folder of a volume/mount point
     *
     *    UTI: public.volume
     *    conform/// to: public.folder
     *
     *
     *  kUTTypePackage
     *
     *    a packaged directory
     *
     *    UTI: com.apple.package
     *    conform/// to: public.directory
     *
     *
     *  kUTTypeBundle
     *
     *    a directory conforming to one of the CFBundle layouts
     *
     *    UTI: com.apple.bundle
     *    conform/// to: public.directory
     *
     *
     *  kUTTypePluginBundle
     *
     *    base type for bundle-based plugins
     *
     *    UTI: com.apple.plugin
     *    conforms to: com.apple.bundle, com.apple.package
     *
     *
     *  kUTTypeSpotlightImporter
     *
     *    a Spotlight metadata importer
     *
     *    UTI: com.apple.metadata-importer
     *    conforms to: com.apple.plugin
     *
     *
     *  kUTTypeQuickLookGenerator
     *
     *    a QuickLook preview generator
     *
     *    UTI: com.apple.quicklook-generator
     *    conforms to: com.apple.plugin
     *
     *
     *  kUTTypeXPCService
     *
     *    an XPC service
     *
     *    UTI: com.apple.xpc-service
     *    conforms to: com.apple.bundle, com.apple.package
     *
     *
     *  kUTTypeFramework
     *
     *    a Mac OS X framework
     *
     *    UTI: com.apple.framework
     *    conforms to: com.apple.bundle
     *
     */
    @available(iOS 3.0, *)
    public static let Folder = UTType(kUTTypeFolder)
    @available(iOS 3.0, *)
    public static let Volume = UTType(kUTTypeVolume)
    @available(iOS 3.0, *)
    public static let Package = UTType(kUTTypePackage)
    @available(iOS 3.0, *)
    public static let Bundle = UTType(kUTTypeBundle)
    @available(iOS 8.0, *)
    public static let PluginBundle = UTType(kUTTypePluginBundle)
    @available(iOS 8.0, *)
    public static let SpotlightImporter = UTType(kUTTypeSpotlightImporter)
    @available(iOS 8.0, *)
    public static let QuickLookGenerator = UTType(kUTTypeQuickLookGenerator)
    @available(iOS 8.0, *)
    public static let XPCService = UTType(kUTTypeXPCService)
    @available(iOS 3.0, *)
    public static let Framework = UTType(kUTTypeFramework)
    
    /*
     *  kUTTypeApplication
     *
     *    base type for OS X applications, launchable items
     *
     *    UTI: com.apple.application
     *    conform/// to: public.executable
     *
     *
     *  kUTTypeApplicationBundle
     *
     *    a bundled application
     *
     *    UTI: com.apple.application-bundle
     *    conforms to: com.apple.application, com.apple.bundle,
     *      com.apple.package
     *
     *
     *  kUTTypeApplicationFile
     *
     *    a single-file Carbon/Classic application 
     *
     *    UTI: com.apple.application-file
     *    conform/// to: com.apple.application, public.data
     *
     *
     *  kUTTypeUnixExecutable
     *
     *    a UNIX executable (flat file)
     *
     *    UTI: public.unix-executable
     *    conform/// to: public.data, public.executable
     *
     *
     *  kUTTypeWindowsExecutable
     *
     *    a Windows executable (.exe files)
     *
     *    UTI: com.microsoft.windows-executable
     *    conform/// to: public.data, public.executable
     *
     *
     *  kUTTypeJavaClass
     *
     *    a Java public class
     *
     *    UTI: com./// un.java-public class
     *    conform/// to: public.data, public.executable
     *
     *
     *  kUTTypeJavaArchive
     *
     *    a Java archive (.jar)
     *
     *    UTI: com.sun.java-archive
     *    conform/// to: public.zip-archive, public.executable
     *
     *
     *  kUTTypeSystemDefaultsPane
     *
     *    a System BMBMBMPrefere pane
     *
     *    UTI: com.apple.systempreference.prefpane
     *    conforms to: com.apple.package, com.apple.bundle
     *
     */
    // Abstract executable types
    @available(iOS 3.0, *)
    public static let Application = UTType(kUTTypeApplication)
    @available(iOS 3.0, *)
    public static let ApplicationBundle = UTType(kUTTypeApplicationBundle)
    @available(iOS 3.0, *)
    public static let ApplicationFile = UTType(kUTTypeApplicationFile)
    @available(iOS 8.0, *)
    public static let UnixExecutable = UTType(kUTTypeUnixExecutable)
    
    // Other platform binaries
    @available(iOS 8.0, *)
    public static let WindowsExecutable = UTType(kUTTypeWindowsExecutable)
    @available(iOS 8.0, *)
    public static let JavaClass = UTType(kUTTypeJavaClass)
    @available(iOS 8.0, *)
    public static let JavaArchive = UTType(kUTTypeJavaArchive)
    
    // Misc. binaries
    @available(iOS 8.0, *)
    public static let SystemPreferencesPane 
        = UTType(kUTTypeSystemPreferencesPane)
    
    /*
     *  kUTTypeGNUZipArchive
     *
     *    a GNU zip archive (gzip)
     *
     *    UTI: org.gnu.gnu-zip-archive
     *    conform/// to: public.data, public.archive
     *
     *
     *  kUTTypeBzip2Archive
     *
     *    a bzip2 archive (.bz2)
     *
     *    UTI: public.bzip2-archive
     *    conform/// to: public.data, public.archive
     *
     *
     *  kUTTypeZipArchive
     *
     *    a zip archive
     *
     *    UTI: public.zip-archive
     *    conforms to: com.pkware.zip-archive
     *
     */
    @available(iOS 8.0, *)
    public static let GNUZipArchive = UTType(kUTTypeGNUZipArchive)
    @available(iOS 8.0, *)
    public static let Bzip2Archive = UTType(kUTTypeBzip2Archive)
    @available(iOS 8.0, *)
    public static let ZipArchive = UTType(kUTTypeZipArchive)
    
    /*
     *  kUTTypeSpreadsheet
     *
     *    base spreadsheet document type
     *
     *    UTI: public.spreadsheet
     *    conform/// to: public.content
     *
     *
     *  kUTTypePresentation
     *
     *    base presentation document type
     *
     *    UTI: public.presentation
     *    conform/// to: public.composite-content
     *
     *
     *  kUTTypeDatabase
     *
     *    a database store
     *
     *    UTI: public.database
     *
     */
    @available(iOS 8.0, *)
    public static let Spreadsheet = UTType(kUTTypeSpreadsheet)
    @available(iOS 8.0, *)
    public static let Presentation = UTType(kUTTypePresentation)
    @available(iOS 8.0, *)
    public static let Database = UTType(kUTTypeDatabase)
    
    /*
     *  kUTTypeVCard
     *
     *    VCard format
     *
     *    UTI: public.vcard
     *    conform/// to: public.text, public.contact
     *
     *
     *  kUTTypeToDoItem
     *
     *    to-do item
     *
     *    UTI: public.to-do-item
     *
     *
     *  kUTTypeCalendarEvent
     *
     *    calendar event
     *
     *    UTI: public.calendar-event
     *
     *
     *  kUTTypeEmailMessage
     *
     *    e-mail message
     *
     *    UTI: public.email-message
     *    conform/// to: public.message
     *
     */
    @available(iOS 3.0, *)
    public static let VCard = UTType(kUTTypeVCard)
    @available(iOS 8.0, *)
    public static let ToDoItem = UTType(kUTTypeToDoItem)
    @available(iOS 8.0, *)
    public static let CalendarEvent = UTType(kUTTypeCalendarEvent)
    @available(iOS 8.0, *)
    public static let EmailMessage = UTType(kUTTypeEmailMessage)
    
    /*
     *  kUTTypeInternetLocation
     *
     *    base type for Apple Internet locations
     *
     *    UTI: com.apple.internet-location
     *    conform/// to: public.data
     *
     */
    @available(iOS 8.0, *)
    public static let InternetLocation = UTType(kUTTypeInternetLocation)
    
    /*
     *  kUTTypeInkText
     *
     *    Opaque InkText data
     *
     *    UTI: com.apple.ink.inktext
     *    conform/// to: public.data
     *
     *
     *  kUTTypeFont
     *
     *    base type for fonts
     *
     *    UTI: public.font
     *
     *
     *  kUTTypeBookmark
     *
     *    bookmark
     *
     *    UTI: public.bookmark
     *
     *
     *  kUTType3DContent
     *
     *    base type for 3D content
     *
     *    UTI: public.3d-content
     *    conform/// to: public.content
     *
     *
     *  kUTTypePKCS12
     *
     *    CS#12 format
     *
     *    UTI: com.rsa.pkcs-12
     *    conform/// to: public.data
     *
     *
     *  kUTTypeX509Certificate
     *
     *    X.509 certificate format
     *
     *    UTI: public.x509-certificate
     *    conform/// to: public.data
     *
     *
     *  kUTTypeElectronicPublication
     *
     *    ePub format
     *
     *    UTI: org.idpf.epub-container
     *    conform/// to: public.data, public.composite-content
     *
     *
     *  kUTTypeLog
     *
     *    console log
     *
     *    UTI: public.log
     *
     */
    @available(iOS 3.0, *)
    public static let InkText = UTType(kUTTypeInkText)
    @available(iOS 8.0, *)
    public static let Font = UTType(kUTTypeFont)
    @available(iOS 8.0, *)
    public static let Bookmark = UTType(kUTTypeBookmark)
    @available(iOS 8.0, *)
    public static let _3DContent = UTType(kUTType3DContent)
    @available(iOS 8.0, *)
    public static let CS12 = UTType(kUTTypePKCS12)
    @available(iOS 8.0, *)
    public static let X509Certificate = UTType(kUTTypeX509Certificate)
    @available(iOS 8.0, *)
    public static let ElectronicPublication 
        = UTType(kUTTypeElectronicPublication)
    @available(iOS 8.0, *)
    public static let Log = UTType(kUTTypeLog)
    
}

// MARK: Additional Enumerated Static Values
extension UTType {
    
    public static let ActionScript = UTType(kUTTypeActionScript)
    public static let CSS = UTType(kUTTypeCSS)
    public static let HTACCESS = UTType(kUTTypeHTACCESS)
    public static let Markdown = UTType(kUTTypeMarkdown)
    public static let YAML = UTType(kUTTypeYAML)
    
}
