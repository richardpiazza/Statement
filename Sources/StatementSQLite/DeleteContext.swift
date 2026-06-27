import Statement

public extension SQLiteStatement {
    enum DeleteContext {}
}

public extension Clause where Context == SQLiteStatement.StatementContext {
    static func DELETE(_ segments: Segment<SQLiteStatement.DeleteContext>...) -> Clause {
        Clause(keyword: .delete, segments: segments)
    }
}

public extension Segment where Context == SQLiteStatement.DeleteContext {
    static func FROM(_ type: (some Entity).Type) -> Segment {
        .clause(keyword: .from, segments: [
            Segment.entity(type),
        ])
    }

    static func FROM(_ entity: any Entity) -> Segment {
        .clause(keyword: .from, segments: [
            Segment.entity(entity),
        ])
    }
}

public extension Clause where Context == SQLiteStatement.StatementContext {
    /// A compound clause 'DELETE FROM x'
    ///
    /// This proxies the following:
    /// ```
    /// .DELETE(
    ///     .FROM(type)
    /// )
    /// ```
    static func DELETE_FROM(_ type: (some Entity).Type) -> Clause {
        .DELETE(
            .FROM(type)
        )
    }

    static func DELETE_FROM(_ entity: any Entity) -> Clause {
        .DELETE(
            .FROM(entity)
        )
    }
}
