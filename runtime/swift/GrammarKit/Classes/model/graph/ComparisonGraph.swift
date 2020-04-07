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

extension ComparisonResult {

    static var lessThan: ComparisonResult { return .orderedAscending }
    static var equalTo: ComparisonResult { return .orderedSame }
    static var greaterThan: ComparisonResult { return .orderedDescending }

    var inverse: ComparisonResult {
        switch self {
        case .lessThan: return .greaterThan
        case .greaterThan: return .lessThan
        default: return .equalTo
        }
    }

    init(_ stringValue: String) {
        switch stringValue {
        case "<": self = .lessThan
        case ">": self = .greaterThan
        default: self = .equalTo
        }
    }

}

extension ComparisonResult: Codable {}

extension ComparisonResult: CustomStringConvertible {

    public var description: String {
        switch self {
        case .lessThan: return "<"
        case .greaterThan: return ">"
        default: return "="
        }
    }

}

public protocol ComparisonGraphNode {

    var id: String { get }

}

public class ComparisonGraph<T: ComparisonGraphNode> {

    public var nodes = [T]()
    public var weights = [String: Int]()
    public var relations = [String: [String: ComparisonResult]]()

    public init(nodes: [T] = []) {
        self.nodes = nodes
    }

    public func connect(_ a: String, _ b: String, _ relation: ComparisonResult) {
        oneWayConnect(a, b, relation)
        oneWayConnect(b, a, relation.inverse)
    }

    public func connect(_ a: String, _ b: String, _ relation: String) {
        switch relation {
        case "<": connect(a, b, .lessThan)
        case ">": connect(a, b, .greaterThan)
        default: connect(a, b, .equalTo)
        }
    }

    public func set(weight: Int, for id: String) {
        weights[id] = weight
    }

    public func compare(_ a: String, _ b: String, _ excluding: [String] = []) -> ComparisonResult {
        if let a = weights[a], let b = weights[b] {
            return (a < b ? .lessThan : a > b ? .greaterThan : .equalTo)
        }
        if let relations = self.relations[a] {
            if let value = relations[b] { return value }
            for (id, relation) in relations {
                guard !excluding.contains(id), relation != .greaterThan else { continue }
                return compare(id, b, excluding + [a, b, id])
            }
        }
        return .equalTo
    }

    public func compare(_ a: T, _ b: T) -> ComparisonResult {
        return compare(a.id, b.id)
    }

    func sorted(reversed: Bool = false) -> [T] {
        return nodes.sorted {
            if reversed { return self.compare($0.id, $1.id) != .lessThan }
            return self.compare($0.id, $1.id) == .lessThan
        }
    }

    fileprivate func oneWayConnect(_ a: String, _ b: String, _ relation: ComparisonResult) {
        var relations = self.relations[a] ?? [:]
        relations[b] = relation
        self.relations[a] = relations
        if relation == .equalTo {
            if let weight = weights[b] {
                set(weight: weight, for: a)
            }
        }
    }

}

extension ComparisonGraph: CustomStringConvertible {

   public var description: String {
        var strings = [String]()
        for (id, map) in relations {
            let weight = weights[id]
            strings.append("\(id)(\(weight ?? 0)) -> \(map)")
        }
        return strings.joined(separator: "\n")
    }

}
