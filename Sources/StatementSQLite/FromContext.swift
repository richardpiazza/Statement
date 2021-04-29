import Statement

public extension SQLiteStatement {
    enum FromContext {}
}

public extension Clause where Context == SQLiteStatement.StatementContext {
    static func FROM(_ segments: Segment<SQLiteStatement.FromContext>...) -> Clause {
        Clause(keyword: .from, segments: segments)
    }
}

public extension Segment where Context == SQLiteStatement.FromContext {
    static func TABLE<T: Table>(_ type: T.Type) -> Segment {
        .table(type)
    }
    
    static func JOIN<T: Table>(_ type: T.Type, on c1: AnyColumn, equals c2: AnyColumn) -> Segment {
        .clause(keyword: .join, segments: [
            Segment<Context>.table(type),
            .keyword(.on),
            .comparison(op: .equal, segments: [
                Segment<Context>.column(c1, tablePrefix: true),
                .column(c2, tablePrefix: true)
            ])
        ])
    }
}

public extension Clause where Context == SQLiteStatement.StatementContext {
    /// A convenience for
    /// ```
    /// .FROM(
    ///     .TABLE(type)
    /// )
    /// ```
    static func FROM_TABLE<T: Table>(_ type: T.Type) -> Clause {
        .FROM(
            .TABLE(type)
        )
    }
    
    @available(*, deprecated, renamed: "FROM_TABLE()")
    static func FROM_TABLE<T: Table>(_ type: T.Type, _ segments: Segment<SQLiteStatement.FromContext>...) -> Clause {
        let table = Segment<Context>.table(type)
        var allSegments: [AnyRenderable] = [table]
        allSegments.append(contentsOf: segments)
        return Clause(keyword: .from, segments: allSegments)
    }
}
