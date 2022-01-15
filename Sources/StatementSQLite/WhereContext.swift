import Statement

public extension SQLiteStatement {
    enum WhereContext {}
}

public extension Clause where Context == SQLiteStatement.StatementContext {
    static func WHERE(_ segments: Segment<SQLiteStatement.WhereContext>...) -> Clause {
        Clause(keyword: .where, segments: segments)
    }
}

public extension Segment where Context == SQLiteStatement.WhereContext {
    /// Performs a conjunctive 'and'.
    static func AND(_ segments: Segment<Context>...) -> Segment {
        .conjunctive(op: .and, segments: segments)
    }
    
    /// Performs a conjunctive 'and'.
    static func OR(_ segments: Segment<Context>...) -> Segment {
        .conjunctive(op: .or, segments: segments)
    }
    
    /// Convenience that builds a comparison predicate.
    static func column<E: Entity>(_ type: E.Type, attribute: Attribute, op: ComparisonOperator, value: DataTypeConvertible) -> Segment {
        .comparison(op: op, segments: [
            Segment<Context>.attribute(type, attribute: attribute),
            .value(value)
        ])
    }
    
    static func column(_ attribute: Attribute, entity: Entity? = nil, op: ComparisonOperator, value: DataTypeConvertible) -> Segment {
        .comparison(op: op, segments: [
            Segment<Context>.attribute(attribute, entity: entity),
            .value(value)
        ])
    }
    
    /// Convenience that builds a logical predicate.
    static func column<E: Entity>(_ type: E.Type, attribute: Attribute, op: LogicalOperator, value: DataTypeConvertible) -> Segment {
        .logical(op: op, segments: [
            Segment<Context>.attribute(type, attribute: attribute),
            .value(value)
        ])
    }
    
    static func column(_ attribute: Attribute, entity: Entity? = nil, op: LogicalOperator, value: DataTypeConvertible) -> Segment {
        .logical(op: op, segments: [
            Segment<Context>.attribute(attribute, entity: entity),
            .value(value)
        ])
    }
}
