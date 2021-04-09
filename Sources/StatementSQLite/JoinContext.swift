import Statement

public extension SQLiteStatement {
    enum JoinContext {}
}

public extension Segment where Context == SQLiteStatement.JoinContext {
    static func ON(_ c1: AnyColumn, _ c2: AnyColumn) -> Segment {
        .clause(
            Clause<SQLiteStatement.JoinContext>(
                keyword: .on,
                segments: [
                    Segment.column(c1, tablePrefix: true),
                    Segment.column(c2, tablePrefix: true)
                ],
                separator: " = "
            )
        )
    }
}
