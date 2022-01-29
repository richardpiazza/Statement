import Statement

public extension SQLiteStatement {
    enum OrderContext {}
}

public extension Clause where Context == SQLiteStatement.StatementContext {
    static func ORDER(_ segments: Segment<SQLiteStatement.OrderContext>...) -> Clause {
        Clause(keyword: .order, segments: segments)
    }
    
    static func ORDER(_ segments: [Segment<SQLiteStatement.OrderContext>]) -> Clause {
        Clause(keyword: .order, segments: segments)
    }
    
    static func ORDER_BY(_ segments: Segment<SQLiteStatement.OrderContext>...) -> Clause {
        ORDER(
            .BY(segments)
        )
    }
}

public extension Segment where Context == SQLiteStatement.OrderContext {
    static func BY(_ segments: Segment<SQLiteStatement.OrderContext>...) -> Segment {
        .clause(keyword: .by, segments: segments)
    }
    
    static func BY(_ segments: [Segment<SQLiteStatement.OrderContext>]) -> Segment {
        .clause(keyword: .by, segments: segments)
    }
    
    static func column<E: Entity>(_ type: E.Type, attribute: Attribute, op: LogicalOperator) -> Segment {
        .logical(op: op, segments: [
            Segment<Context>.attribute(type, attribute: attribute)
        ])
    }
    
    static func column(_ attribute: Attribute, entity: Entity? = nil, op: LogicalOperator) -> Segment {
        .logical(op: op, segments: [
            Segment<Context>.attribute(attribute, entity: entity)
        ])
    }
}
