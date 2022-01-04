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
    @available(*, deprecated)
    static func TABLE<T: Table>(_ type: T.Type) -> Segment {
        .table(type)
    }
    
    static func TABLE<E: Entity>(_ type: E.Type) -> Segment {
        TABLE(E.init())
    }
    
    static func TABLE(_ entity: Entity) -> Segment {
        .entity(entity)
    }
    
    @available(*, deprecated)
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
    
    static func JOIN_ON<E: Entity, J: Entity>(_ type: E.Type, attribute a1: Attribute, on: J.Type, equals a2: Attribute) -> Segment {
        JOIN_ON(E.init(), attribute: a1, on: J.init(), equals: a2)
    }
    
    static func JOIN_ON(_ e1: Entity, attribute a1: Attribute, on e2: Entity, equals a2: Attribute) -> Segment {
        .clause(keyword: .join, segments: [
            Segment<Context>.entity(e1),
            .keyword(.on),
            .comparison(op: .equal, segments: [
                Segment<Context>.attribute(a1, entity: e1),
                .attribute(a2, entity: e2)
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
    @available(*, deprecated)
    static func FROM_TABLE<T: Table>(_ type: T.Type) -> Clause {
        .FROM(
            .TABLE(type)
        )
    }
    
    static func FROM_TABLE<E: Entity>(_ type: E.Type) -> Clause {
        FROM_TABLE(E.init())
    }
    
    static func FROM_TABLE(_ table: Entity) -> Clause {
        .FROM(
            .TABLE(table)
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
