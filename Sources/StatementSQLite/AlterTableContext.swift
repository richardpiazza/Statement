import Statement

public extension SQLiteStatement {
    enum AlterTableContext {}
}

public extension Clause where Context == SQLiteStatement.StatementContext {
    /// Change the name of a table or column.
    static func ALTER_TABLE<E: Entity>(_ type: E.Type, _ segments: Segment<SQLiteStatement.AlterTableContext>...) -> Clause {
        var clauseSegments = segments
        clauseSegments.insert(.entity(type), at: 0)
        return Clause(keyword: .compound(.alter, .table), segments: clauseSegments)
    }
    
    static func ALTER_TABLE(_ entity: Entity, _ segments: Segment<SQLiteStatement.AlterTableContext>...) -> Clause {
        var clauseSegments = segments
        clauseSegments.insert(.entity(entity), at: 0)
        return Clause(keyword: .compound(.alter, .table), segments: clauseSegments)
    }
}

public extension Segment where Context == SQLiteStatement.AlterTableContext {
    /// Change the name of a table.
    static func RENAME_TO<E: Entity>(_ type: E.Type) -> Segment {
        .clause(keyword: .compound(.rename, .to), segments: [
            Segment.entity(type)
        ])
    }
    
    static func RENAME_TO(_ table: Entity) -> Segment {
        .clause(keyword: .compound(.rename, .to), segments: [
            Segment.entity(table)
        ])
    }
    
    /// Change the name of a single column in a table.
    static func RENAME_COLUMN(_ from: Attribute, to: Attribute) -> Segment {
        .clause(keyword: .compound(.rename, .column), segments: [
            Segment.attribute(from),
            .keyword(.to),
            .attribute(to)
        ])
    }
    
    /// Add a column to the table.
    ///
    /// SQLite will automatically append columns to the end of a table.
    ///
    /// ## Examples
    /// * `ADD COLUMN language_code TEXT NOT NULL`
    ///
    /// - parameter attribute: The column (`Attribute`) to add to the table.
    static func ADD_COLUMN(_ attribute: Attribute) -> Segment {
        .clause(
            keyword: .compound(.add, .column),
            segments: [
                Segment.attribute(attribute),
                Segment.raw(attribute.dataType.sqliteDataType),
                .if(attribute.notNull, .keyword(.compound(.not, .null))),
                .if(attribute.unique, .keyword(.unique)),
                .unwrap(attribute.defaultValue, transform: {
                    .raw("\(Keyword.default.rawValue) \($0.sqliteArgument)")
                })
            ]
        )
    }
    
    /// Removes a column from a table.
    ///
    /// ## Examples
    /// * `DROP COLUMN language_code`
    ///
    /// - parameter attribute: The column (`Attribute`) to remove from the table.
    static func DROP_COLUMN(_ attribute: Attribute) -> Segment {
        .clause(
            keyword: .compound(.drop, .column),
            segments: [
                Segment.attribute(attribute)
            ]
        )
    }
}
