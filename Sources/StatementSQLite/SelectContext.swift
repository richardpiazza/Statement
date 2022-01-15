import Statement

public extension SQLiteStatement {
    enum SelectContext {}
}

public extension Clause where Context == SQLiteStatement.StatementContext {
    static func SELECT(_ segments: Segment<SQLiteStatement.SelectContext>...) -> Clause {
        Clause(keyword: .select, segments: segments, separator: ", ")
    }
    
    static func SELECT_DISTINCT(_ segments: Segment<SQLiteStatement.SelectContext>...) -> Clause {
        Clause(keyword: .compound(.select, .distinct), segments: segments, separator: ", ")
    }
}
