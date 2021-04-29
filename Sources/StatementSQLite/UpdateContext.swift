import Statement

public extension SQLiteStatement {
    enum UpdateContext {}
}

public extension Clause where Context == SQLiteStatement.StatementContext {
    static func UPDATE(_ segments: Segment<SQLiteStatement.UpdateContext>...) -> Clause {
        Clause(keyword: .update, segments: segments)
    }
}

public extension Segment where Context == SQLiteStatement.UpdateContext {
    static func TABLE<T: Table>(_ type: T.Type) -> Segment {
        .table(type)
    }
    
    static let OR_ABORT: Segment = .keyword(.compound(.or, .abort))
    static let OR_FAIL: Segment = .keyword(.compound(.or, .fail))
    static let OR_IGNORE: Segment = .keyword(.compound(.or, .ignore))
    static let OR_REPLACE: Segment = .keyword(.compound(.or, .replace))
    static let OR_ROLLBACK: Segment = .keyword(.compound(.or, .rollback))
}

public extension Clause where Context == SQLiteStatement.StatementContext {
    /// A convenience for
    /// ```
    /// .UPDATE(
    ///     .TABLE(type)
    /// )
    /// ```
    static func UPDATE_TABLE<T: Table>(_ type: T.Type) -> Clause {
        .UPDATE(
            .TABLE(type)
        )
    }
    
    @available(*, deprecated, renamed: "UPDATE_TABLE()")
    static func UPDATE_TABLE<T: Table>(_ type: T.Type, _ segments: Segment<SQLiteStatement.UpdateContext>...) -> Clause {
        let table = Segment<Context>.table(type)
        var allSegments: [AnyRenderable] = [table]
        allSegments.append(contentsOf: segments)
        return Clause(keyword: .update, segments: allSegments)
    }
}
