import Foundation

public enum Segment<Context>: Sendable {
    case raw(String)
    case clause(Clause<Context>)
    case comparisonPredicate(ComparisonPredicate<Context>)
    case logicalPredicate(LogicalPredicate<Context>)
    case conjunctivePredicate(ConjunctivePredicate<Context>)
    case group(Group<Context>)
    case empty
}

extension Segment: Renderable {
    public func render(into renderer: any Renderer) {
        switch self {
        case .raw(let identifier):
            renderer.addRaw(identifier)
        case .clause(let clause):
            renderer.addClause(clause)
        case .comparisonPredicate(let predicate):
            renderer.addComparisonPredicate(predicate)
        case .logicalPredicate(let predicate):
            renderer.addLogicalPredicate(predicate)
        case .conjunctivePredicate(let predicate):
            renderer.addConjunctivePredicate(predicate)
        case .group(let group):
            renderer.addGroup(group)
        case .empty:
            break
        }
    }
}

public extension Segment {
    static func clause(keyword: Keyword, segments: [Segment<some Any>]) -> Segment {
        .clause(Clause(keyword: keyword, segments: segments))
    }

    static func comparison(op: ComparisonOperator, segments: [Segment<some Any>]) -> Segment {
        .comparisonPredicate(ComparisonPredicate(op, elements: segments))
    }

    static func logical(op: LogicalOperator, segments: [Segment<some Any>]) -> Segment {
        .logicalPredicate(LogicalPredicate(op, elements: segments))
    }

    static func conjunctive(op: ConjunctiveOperator, segments: [Segment<some Any>]) -> Segment {
        .conjunctivePredicate(ConjunctivePredicate(op, elements: segments))
    }

    static func group(segments: [Segment<some Any>]) -> Segment {
        .group(Group(segments: segments))
    }

    /// A `Segment` that represents a SQL keyword.
    static func keyword(_ keyword: Keyword) -> Self {
        .raw(keyword.rawValue)
    }

    /// A `Segment` that outputs the provided entity identifier.
    static func entity<E: Entity>(_ type: E.Type) -> Self {
        .raw(E.identifier)
    }

    static func entity(_ entity: any Entity) -> Self {
        .raw(type(of: entity).identifier)
    }

    /// A `Segment` that outputs the provided `Attribute` identifier prefixed by the `Entity` identifier.
    static func attribute<E: Entity>(_ type: E.Type, attribute: any Attribute) -> Self {
        .raw([E.identifier, attribute.identifier].compactMap(\.self).joined(separator: "."))
    }

    /// A `Segment` that outputs the provided `Attribute` identifier with an optional `Entity` identifier prefix.
    static func attribute(_ attribute: any Attribute, entity: (any Entity)? = nil) -> Self {
        let entityIdentifier: String? = (entity != nil) ? type(of: entity!).identifier : nil
        return .raw([entityIdentifier, attribute.identifier].compactMap(\.self).joined(separator: "."))
    }
}

public extension Segment {
    /// Performs a logical 'if' check for the provided condition.
    static func `if`(_ condition: Bool, _ segment: Segment, else fallback: Segment? = nil) -> Segment {
        guard condition else {
            return fallback ?? .empty
        }

        return segment
    }

    /// Unwraps and transforms the provided value.
    static func unwrap<T>(_ optional: T?, transform: (T) throws -> Segment, else fallback: Segment = .empty) rethrows -> Segment {
        try optional.map(transform) ?? fallback
    }

    /// Processes a sequence into a `Group`
    static func forEach<S: Sequence>(_ sequence: S, _ transform: (S.Element) throws -> Segment) rethrows -> Segment {
        try .group(Group(segments: sequence.map(transform)))
    }
}
