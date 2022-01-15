import Statement

public extension SQLiteStatement {
    enum JoinContext {}
}

public extension Clause where Context == SQLiteStatement.StatementContext {
    static func JOIN(_ segments: Segment<SQLiteStatement.JoinContext>...) -> Clause {
        Clause(keyword: .join, segments: segments)
    }
}
