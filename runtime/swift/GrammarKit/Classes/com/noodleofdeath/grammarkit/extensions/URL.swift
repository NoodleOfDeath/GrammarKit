//
//  URL.swift
//  SwiftyFileSystem
//
//  Created by MORGAN, THOMAS B on 1/30/19.
//

import Foundation

extension URL {
    
    var resourceType: URLFileResourceType {
        return ((try? resourceValues(forKeys: [.fileResourceTypeKey]))?.fileResourceType) ?? .unknown
    }
    
    /// `true` if, and only if, a resource physically exists at `fileURL`.
    var fileExists: Bool {
        return (try? checkResourceIsReachable()) ?? false
    }
    
    /// `true` if, and only if, this resource is a local resource.
    var isLocal: Bool {
        return path.contains(FileSystem.documentPath)
    }
    
    /// `true` if this item is synced to the cloud, `false` if it is only a
    /// local file.
    var isUbiquitous: Bool {
        if let isUbitquitous = ((try? resourceValues(forKeys: [.isUbiquitousItemKey]))?.isUbiquitousItem) { return isUbitquitous }
        guard let ubiquityPath = FileSystem.ubiquityPath else { return false }
        return path.contains(ubiquityPath)
    }
    
    /// `true` if, and only if, this resource is a regular file, or symbolic link to a regular file.
    var isRegularFile: Bool {
        return ((try? resourceValues(forKeys: [.isRegularFileKey]))?.isRegularFile) ?? false
    }
    
    /// `true` if, and only if, this resource is a directory, or symbolic link to a directory.
    var isDirectory: Bool {
        return ((try? resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory) ?? false
    }
    
    /// `true` if, and only if, this resource is a symbolic link.
    var isSymbolicLink: Bool {
        return ((try? resourceValues(forKeys: [.isSymbolicLinkKey]))?.isSymbolicLink) ?? false
    }
    
    /// `true` if, and only if, the filename of this resource begins with `.` or `~`.
    var isInferredHidden: Bool {
        return [".", "~"].contains(lastPathComponent.firstCharacter)
    }
    
    /// `true` for resources normally not displayed to users.
    var isHidden: Bool {
        return ((try? resourceValues(forKeys: [.isHiddenKey]))?.isHidden) ?? false
    }
    
    /// Returns `true` if this resource is hidden, using a specified
    /// `includeInferred` flag to allow documents prefixed with `.` or `~`,
    /// to be considered hidden.
    ///
    /// - Parameters:
    ///     - includeInferred: if `true` is passed, documents prefixed
    /// with `.` or `~` will be considered hidden. Default is `true`.
    ///
    /// - Parameters:
    /// - Returns: `true` if this resource is hidden, using a specified
    /// `includeInferred` flag to allow documents prefixed with `.` or `~`,
    /// to be considered hidden.
    func isHidden(includeInferred: Bool = true) -> Bool {
        return isHidden && (!includeInferred || (includeInferred && isInferredHidden))
    }
    
    /// The file size of this resource, if, and only if, it is not a directory.
    var fileSize: Int {
        return ((try? resourceValues(forKeys: [.fileSizeKey]))?.fileSize) ?? -1
    }
    
    /// Attempts to asynchronously calculate the size of all resources contained
    /// in this file if it is a directory and callack a specified completion
    /// block when finished.
    ///
    /// - Parameters:
    ///     - completion: block to run when the calculation is complete.
    func sizeOfContents(completionHandler: @escaping (Int) -> ()) {
        guard isDirectory else {
            completionHandler(fileSize)
            return
        }
        DispatchQueue.global().async {
            var size = 0
            FileSystem.contentsOfDirectory(at: self).forEach {
                $0.sizeOfContents { size += $0 }
            }
            DispatchQueue.main.async {
                completionHandler(size)
            }
        }
    }
    
    /// Number of files contained in this resource, if, and only if, it is a
    /// directory.
    var fileCount: Int { return fileCount() }
    
    /// Returns the number of files contained in this resource, if, and only
    /// if, it is a directory and using specified resource keys and enumerating
    /// options.
    ///
    /// - Parameters:
    ///     - resourceKeys: to use when enumerating the contents of this
    /// directory.
    ///     - options: to use when enumerating the contents of this
    /// directory.
    /// - Returns: the number of files contained in this resource, if,
    /// and only if, it is a directory and using specified resource keys and
    /// enumerating options.
    func fileCount(includingPropertiesForKeys resourceKeys: [URLResourceKey] = [], options: FileManager.DirectoryEnumerationOptions = [.skipsSubdirectoryDescendants]) -> Int {
        guard isDirectory else { return 0 }
        return FileSystem
            .contentsOfDirectory(at: self,
                                 includingPropertiesForKeys: resourceKeys,
                                 options: options).count
    }
    
    /// Date this resource was created or `distantFuture` if unobtainable.
    var creationDate: Date {
        return ((try? resourceValues(forKeys:
            [.creationDateKey]))?.creationDate) ?? .distantFuture
    }
    
    /// Date this resource was last accessed or `distantFuture` if unobtainable.
    var contentAccessDate: Date {
        return ((try? resourceValues(forKeys:
            [.contentAccessDateKey]))?.contentAccessDate) ?? .distantFuture
    }
    
    /// Date this resource was last modified choosing the most recent
    /// between `attributeModificationDate` and `contentModificationDate` or
    /// `distantFuture` if unobtainable.
    var modificationDate: Date {
        return attributeModificationDate > contentModificationDate ?
            attributeModificationDate : contentModificationDate
    }
    
    /// Date the the attributes of this resource were last modified.
    var attributeModificationDate: Date {
        return ((try? resourceValues(forKeys:
            [.attributeModificationDateKey]))?.attributeModificationDate) ??
            .distantFuture
    }
    
    /// Date the the contents of this resource were last modified.
    var contentModificationDate: Date {
        return ((try? resourceValues(forKeys:
            [.contentModificationDateKey]))?.contentModificationDate) ??
            .distantFuture
    }
    
}
