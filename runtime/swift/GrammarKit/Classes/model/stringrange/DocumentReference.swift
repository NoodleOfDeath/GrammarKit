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

import UIKit

/// Specifications for a URL resource reference.
public protocol DocumentReferenceProtocol: StringRangeProtocol {

    /// Document being referenced.
    var document: UIDocument? { get }

}

/// Base implementation for a `DocumentReferenceProtocol`.
open class DocumentReference: StringRange, DocumentReferenceProtocol {

    // MARK: - DocumentReferenceProtocol Properties

    open var document: UIDocument?

    // MARK: - Comparable Methods

    public static func < (lhs: DocumentReference, rhs: DocumentReference) -> Bool {
        guard lhs.document?.fileURL == rhs.document?.fileURL else { return false }
        return lhs.start < rhs.start
    }

    // MARK: - Equatable Methods

    public static func == (lhs: DocumentReference, rhs: DocumentReference) -> Bool {
        return (lhs.document, lhs.start, lhs.end) == (rhs.document, rhs.start, rhs.end)
    }

}
