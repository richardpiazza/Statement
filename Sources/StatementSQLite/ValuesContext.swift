import Statement

public extension SQLiteStatement {
    enum ValuesContext {}
}

public extension Clause where Context == SQLiteStatement.StatementContext {
    static func VALUES(_ segments: Segment<SQLiteStatement.ValuesContext>...) -> Clause {
        Clause(keyword: .values, segments: [
            Segment.group(Group<Context>(segments: segments))
        ])
    }
}
