import Statement

public extension SQLiteStatement {
    enum SetContext {}
}

public extension Clause where Context == SQLiteStatement.StatementContext {
    static func SET(_ segments: Segment<SQLiteStatement.SetContext>...) -> Clause {
        Clause(keyword: .set, segments: segments, separator: ", ")
    }
}

public extension Segment where Context == SQLiteStatement.SetContext {
    static func column(_ column: AnyColumn, op: ComparisonOperator, value: Encodable) -> Segment {
        .comparison(op: op, segments: [
            Segment<SQLiteStatement.SetContext>.column(column, tablePrefix: true),
            .value(value)
        ])
    }
}
