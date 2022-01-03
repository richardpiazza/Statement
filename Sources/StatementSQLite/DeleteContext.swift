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
    @available(*, deprecated)
    static func FROM<T: Table>(_ type: T.Type) -> Segment {
        .clause(keyword: .from, segments: [
            Segment.table(type)
        ])
    }
    
    static func FROM<E: Entity>(_ type: E.Type) -> Segment {
        FROM(E.init())
    }
    
    static func FROM(_ entity: Entity) -> Segment {
        .clause(keyword: .from, segments: [
            Segment.entity(entity)
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
    @available(*, deprecated)
    static func DELETE_FROM<T: Table>(_ type: T.Type) -> Clause {
        .DELETE(
            .FROM(type)
        )
    }
    
    static func DELETE_FROM(_ table: Entity) -> Clause {
        .DELETE(
            .FROM(table)
        )
    }
    
    @available(*, deprecated, renamed: "DELETE_FROM()")
    static func DELETE_FROM_TABLE<T:Table>(_ type: T.Type, _ segments: Segment<SQLiteStatement.DeleteContext>...) -> Clause {
        .DELETE(
            .FROM(type)
        )
    }
}
