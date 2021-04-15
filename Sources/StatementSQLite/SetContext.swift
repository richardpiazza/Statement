import Statement

public extension SQLiteStatement {
    enum SetContext {}
}

public extension Segment where Context == SQLiteStatement.SetContext {
    static func column(_ column: AnyColumn, op: ComparisonOperator, value: Encodable) -> Segment {
        .comparison(op: op, segments: [
            Segment<SQLiteStatement.SetContext>.column(column, tablePrefix: true),
            .value(value)
        ])
    }
}
