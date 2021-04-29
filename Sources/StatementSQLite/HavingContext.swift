import Statement

public extension SQLiteStatement {
    enum HavingContext {}
}

public extension Clause where Context == SQLiteStatement.StatementContext {
    static func HAVING(_ segments: Segment<SQLiteStatement.HavingContext>...) -> Clause {
        Clause(keyword: .having, segments: segments)
    }
}

