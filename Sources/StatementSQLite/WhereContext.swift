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
    static func column(_ column: AnyColumn, tablePrefix: Bool = true, op: ComparisonOperator, value: Encodable) -> Segment {
        .comparison(op: op, segments: [
            // TODO: This context should probably not be set here.
            Segment<SQLiteStatement.SetContext>.column(column, tablePrefix: tablePrefix),
            .value(value)
        ])
    }
}
