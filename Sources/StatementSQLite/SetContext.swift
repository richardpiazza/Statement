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
    @available(*, deprecated)
    static func column(_ column: AnyColumn, tablePrefix: Bool = false, op: ComparisonOperator, value: Encodable) -> Segment {
        .comparison(op: op, segments: [
            Segment<SQLiteStatement.SetContext>.column(column, tablePrefix: tablePrefix),
            .value(value)
        ])
    }
    
    static func attribute<E: Entity>(_ type: E.Type, attribute: Attribute, op: ComparisonOperator, value: DataTypeConvertible) -> Segment {
        self.attribute(attribute, entity: E.init(), op: op, value: value)
    }
    
    static func attribute(_ attribute: Attribute, entity: Entity? = nil, op: ComparisonOperator, value: DataTypeConvertible) -> Segment {
        .comparison(op: op, segments: [
            Segment<SQLiteStatement.SetContext>.attribute(attribute, entity: entity),
            .value(value)
        ])
    }
}
