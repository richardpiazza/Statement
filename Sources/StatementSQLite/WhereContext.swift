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
    @available(*, deprecated)
    static func column(_ column: AnyColumn, tablePrefix: Bool = false, op: ComparisonOperator, value: Encodable) -> Segment {
        .comparison(op: op, segments: [
            Segment<Context>.column(column, tablePrefix: tablePrefix),
            .value(value)
        ])
    }
    
    static func column<E: Entity>(_ type: E.Type, attribute: Attribute, op: ComparisonOperator, value: DataTypeConvertible) -> Segment {
        self.column(attribute, entity: type.init(), op: op, value: value)
    }
    
    static func column(_ attribute: Attribute, entity: Entity? = nil, op: ComparisonOperator, value: DataTypeConvertible) -> Segment {
        .comparison(op: op, segments: [
            Segment<Context>.attribute(attribute, entity: entity),
            .value(value)
        ])
    }
    
    /// Convenience that builds a logical predicate.
    @available(*, deprecated)
    static func column(_ column: AnyColumn, tablePrefix: Bool = false, op: LogicalOperator, value: Encodable) -> Segment {
        .logical(op: op, segments: [
            Segment<Context>.column(column, tablePrefix: tablePrefix),
            .value(value)
        ])
    }
    
    static func column<E: Entity>(_ type: E.Type, attribute: Attribute, op: LogicalOperator, value: DataTypeConvertible) -> Segment {
        self.column(attribute, entity: E.init(), op: op, value: value)
    }
    
    static func column(_ attribute: Attribute, entity: Entity? = nil, op: LogicalOperator, value: DataTypeConvertible) -> Segment {
        .logical(op: op, segments: [
            Segment<Context>.attribute(attribute, entity: entity),
            .value(value)
        ])
    }
}
