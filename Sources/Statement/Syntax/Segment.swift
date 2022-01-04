import Foundation

public enum Segment<Context> {
    case raw(String)
    case clause(Clause<Context>)
    case comparisonPredicate(ComparisonPredicate<Context>)
    case logicalPredicate(LogicalPredicate<Context>)
    case conjunctivePredicate(ConjunctivePredicate<Context>)
    case group(Group<Context>)
    case empty
}

extension Segment: AnyRenderable {
    public func render(into renderer: Renderer) {
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
    static func clause<C>(keyword: Keyword, segments: [Segment<C>]) -> Segment {
        .clause(Clause(keyword: keyword, segments: segments))
    }
    
    static func comparison<C>(op: ComparisonOperator, segments: [Segment<C>]) -> Segment {
        .comparisonPredicate(ComparisonPredicate(op, elements: segments))
    }
    
    static func logical<C>(op: LogicalOperator, segments: [Segment<C>]) -> Segment {
        .logicalPredicate(LogicalPredicate(op, elements: segments))
    }
    
    static func conjunctive<C>(op: ConjunctiveOperator, segments: [Segment<C>]) -> Segment {
        .conjunctivePredicate(ConjunctivePredicate(op, elements: segments))
    }
    
    static func group<C>(segments: [Segment<C>]) -> Segment {
        .group(Group(segments: segments))
    }
    
    /// A `Segment` that represents a SQL keyword.
    static func keyword(_ keyword: Keyword) -> Self {
        .raw(keyword.rawValue)
    }
    
    /// A `Segment` that outputs the provided table name.
    @available(*, deprecated)
    static func table<T: Table>(_ type: T.Type) -> Self {
        return .raw(T.schema.name)
    }
    
    static func entity<E: Entity>(_ type: E.Type) -> Self {
        entity(E.init())
    }
    
    static func entity(_ entity: Entity) -> Self {
        .raw(entity.tableName)
    }
    
    /// A `Segment` that outputs the provided column name with an optional table prefix.
    @available(*, deprecated, renamed: "column(_:table:)")
    static func column(_ column: AnyColumn, tablePrefix: Bool = false) -> Self {
        .raw(tablePrefix ? column.identifier : column.name)
    }
    
    @available(*, deprecated, renamed: "attribute(_:entity:)")
    static func column(_ column: Attribute, table: Entity? = nil) -> Self {
        .raw([table?.tableName, column.columnName].compactMap { $0 }.joined(separator: "."))
    }
    
    static func attribute<E: Entity>(_ type: E.Type, attribute: Attribute) -> Self {
        self.attribute(attribute, entity: E.init())
    }
    
    static func attribute(_ attribute: Attribute, entity: Entity? = nil) -> Self {
        .raw([entity?.tableName, attribute.columnName].compactMap { $0 }.joined(separator: "."))
    }
    
    /// Convenience wrapper that outputs the `.sqlArgument()` of the provided value.
    @available(*, deprecated)
    static func value(_ encodable: Encodable) -> Self {
        .raw(encodable.sqlArgument())
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
