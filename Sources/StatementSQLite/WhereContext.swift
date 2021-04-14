import Statement

public extension SQLiteStatement {
    enum WhereContext {}
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
    static func column(_ column: AnyColumn, op: ComparisonOperator, value: Encodable) -> Segment {
        .comparison(op: op, segments: [
            Segment<SQLiteStatement.SetContext>.column(column, tablePrefix: true),
            .value(value)
        ])
    }
}
