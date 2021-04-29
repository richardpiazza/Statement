import Statement

public extension SQLiteStatement {
    enum InsertContext {}
    @available(*, deprecated, renamed: "InsertContext")
    enum InsertIntoContext {}
}

public extension Clause where Context == SQLiteStatement.StatementContext {
    static func INSERT(_ segments: Segment<SQLiteStatement.InsertContext>...) -> Clause {
        Clause(keyword: .insert, segments: segments)
    }
}

public extension Segment where Context == SQLiteStatement.InsertContext {
    static func INTO<T: Table>(_ type: T.Type) -> Segment {
        .clause(keyword: .into, segments: [
            Segment.table(type)
        ])
    }
    
    static let OR_ABORT: Segment = .keyword(.compound(.or, .abort))
    static let OR_FAIL: Segment = .keyword(.compound(.or, .fail))
    static let OR_IGNORE: Segment = .keyword(.compound(.or, .ignore))
    static let OR_REPLACE: Segment = .keyword(.compound(.or, .replace))
    static let OR_ROLLBACK: Segment = .keyword(.compound(.or, .rollback))
}

public extension Clause where Context == SQLiteStatement.StatementContext {
    /// ```
    /// .INSERT(
    ///     .INTO(type)
    ///     .group(segments)
    /// )
    /// ```
    static func INSERT_INTO<T: Table>(_ type: T.Type, _ segments: Segment<SQLiteStatement.InsertContext>...) -> Clause {
        .INSERT(
            .INTO(type),
            .group(segments: segments)
        )
    }
    
    @available(*, deprecated, renamed: "INSERT_INTO()")
    static func INSERT_INTO_TABLE<T: Table>(_ type: T.Type, _ segments: Segment<SQLiteStatement.InsertIntoContext>...) -> Clause {
        let table = Segment<Context>.table(type)
        let group = Group<Context>(segments: segments)
        let into = Clause(keyword: .into, segments: [table, group])
        return Clause(keyword: .insert, segments: [
            Segment.clause(into)
        ])
    }
}
