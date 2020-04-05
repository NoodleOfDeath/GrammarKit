//
//  ComparisonGraph.swift
//  GrammarKit
//
//  Created by MORGAN, THOMAS B (CTR) on 4/5/20.
//

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

public class ComparisonGraph {

    public var nodes = [ComparisonGraphNode]()
    public var weights = [String: Int]()
    public var arcs = [String: [String: ComparisonResult]]()

    public init(nodes: [ComparisonGraphNode] = []) {
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
        if let arcs = self.arcs[a] {
            if let value = arcs[b] { return value }
            for (id, relation) in arcs {
                guard !excluding.contains(id), relation != .greaterThan else { continue }
                return compare(id, b, excluding + [a, b, id])
            }
        }
        return .equalTo
    }

    public func compare<NodeType: ComparisonGraphNode>(_ a: NodeType, _ b: NodeType) -> ComparisonResult {
        return compare(a.id, b.id)
    }

    public func sorted() -> [ComparisonGraphNode] {
        return nodes.sorted {
            return self.compare($0.id, $1.id) == .lessThan
        }
    }

    fileprivate func oneWayConnect(_ a: String, _ b: String, _ relation: ComparisonResult) {
        var arcs = self.arcs[a] ?? [:]
        arcs[b] = relation
        self.arcs[a] = arcs
    }

}

extension ComparisonGraph: CustomStringConvertible {

   public var description: String {
        var strings = [String]()
        for (id, map) in arcs {
            let weight = weights[id]
            strings.append("\(id)(\(weight ?? 0)) -> \(map)")
        }
        return strings.joined(separator: "\n")
    }

}
