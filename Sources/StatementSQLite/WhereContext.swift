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
    static func column(_ column: AnyColumn, tablePrefix: Bool = false, op: ComparisonOperator, value: Encodable) -> Segment {
        .comparison(op: op, segments: [
            Segment<Context>.column(column, tablePrefix: tablePrefix),
            .value(value)
        ])
    }
    
    /// Convenience that builds a logical predicate.
    static func column(_ column: AnyColumn, tablePrefix: Bool = false, op: LogicalOperator, value: Encodable) -> Segment {
        .logical(op: op, segments: [
            Segment<Context>.column(column, tablePrefix: tablePrefix),
            .value(value)
        ])
    }
}
