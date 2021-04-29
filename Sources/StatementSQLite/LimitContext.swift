import Statement

public extension SQLiteStatement {
    enum LimitContext {}
}

public extension Clause where Context == SQLiteStatement.StatementContext {
    static func LIMIT(_ limit: Int) -> Clause {
        Clause(keyword: .limit, segments: [
            Segment<SQLiteStatement.LimitContext>.raw("\(limit)")
        ])
    }
}
