import Statement

public extension SQLiteStatement {
    enum SelectContext {}
}

public extension Clause where Context == SQLiteStatement.StatementContext {
    static func SELECT(_ segments: Segment<SQLiteStatement.SelectContext>...) -> Clause {
        Clause(keyword: .select, segments: segments, separator: ", ")
    }
}

public extension Segment where Context == SQLiteStatement.SelectContext {
}
