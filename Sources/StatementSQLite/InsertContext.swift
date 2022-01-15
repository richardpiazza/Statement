import Statement

public extension SQLiteStatement {
    enum InsertContext {}
}

public extension Clause where Context == SQLiteStatement.StatementContext {
    static func INSERT(_ segments: Segment<SQLiteStatement.InsertContext>...) -> Clause {
        Clause(keyword: .insert, segments: segments)
    }
}

public extension Segment where Context == SQLiteStatement.InsertContext {
    static func INTO<E: Entity>(_ type: E.Type) -> Segment {
        .clause(keyword: .into, segments: [
            Segment.entity(type)
        ])
    }
    
    static func INTO(_ entity: Entity) -> Segment {
        .clause(keyword: .into, segments: [
            Segment.entity(entity)
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
    static func INSERT_INTO<E: Entity>(_ type: E.Type, _ segments: Segment<SQLiteStatement.InsertContext>...) -> Clause {
        .INSERT(
            .INTO(type),
            .group(segments: segments)
        )
    }
    
    static func INSERT_INTO(_ entity: Entity, _ segments: Segment<SQLiteStatement.InsertContext>...) -> Clause {
        .INSERT(
            .INTO(entity),
            .group(segments: segments)
        )
    }
}
