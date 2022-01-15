import Statement

public extension SQLiteStatement {
    enum SetContext {}
}

public extension Clause where Context == SQLiteStatement.StatementContext {
    static func SET(_ segments: Segment<SQLiteStatement.SetContext>...) -> Clause {
        Clause(keyword: .set, segments: segments, separator: ", ")
    }
}

public extension Segment where Context == SQLiteStatement.SetContext {
    static func column<E: Entity>(_ type: E.Type, attribute: Attribute, op: ComparisonOperator, value: DataTypeConvertible) -> Segment {
        .comparison(op: op, segments: [
            Segment<SQLiteStatement.SetContext>.attribute(type, attribute: attribute),
            .value(value)
        ])
    }
    
    static func column(_ attribute: Attribute, entity: Entity? = nil, op: ComparisonOperator, value: DataTypeConvertible) -> Segment {
        .comparison(op: op, segments: [
            Segment<SQLiteStatement.SetContext>.attribute(attribute, entity: entity),
            .value(value)
        ])
    }
}
