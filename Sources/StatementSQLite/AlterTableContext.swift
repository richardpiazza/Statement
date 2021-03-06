import Statement

public extension SQLiteStatement {
    enum AlterTableContext {}
}

public extension Clause where Context == SQLiteStatement.StatementContext {
    /// Change a `Table` name or `Column`s.
    static func ALTER_TABLE<T: Table>(_ type: T.Type, _ segments: Segment<SQLiteStatement.AlterTableContext>...) -> Clause {
        var clauseSegments = segments
        clauseSegments.insert(.table(type), at: 0)
        return Clause(keyword: .compound(.alter, .table), segments: clauseSegments)
    }
}

public extension Segment where Context == SQLiteStatement.AlterTableContext {
    /// Change the name of a `Table`.
    static func RENAME_TO<T: Table>(_ type: T.Type) -> Segment {
        .clause(keyword: .compound(.rename, .to), segments: [
            Segment.table(type)
        ])
    }
    
    /// Change the name of a single `Column` in a table.
    static func RENAME_COLUMN(_ column: AnyColumn, to: AnyColumn) -> Segment {
        .clause(keyword: .compound(.rename, .column), segments: [
            Segment.column(column),
            .keyword(.to),
            .column(to)
        ])
    }
    
    /// Add a column to the table.
    ///
    /// SQLite will automatically append columns to the end of a table.
    ///
    /// ## Examples
    /// * `ADD COLUMN language_code TEXT NOT NULL`
    ///
    /// - parameter column: The column to add to the table.
    static func ADD_COLUMN(_ column: AnyColumn) -> Segment {
        .clause(
            keyword: .compound(.add, .column),
            segments: [
                Segment.column(column),
                Segment.raw(column.dataType),
                .if(column.notNull, .keyword(.compound(.not, .null))),
                .if(column.unique, .keyword(.unique)),
                .unwrap(column.defaultValue, transform: { .raw("\(Keyword.default.rawValue) \($0.sqlArgument())") })
            ]
        )
    }
    
    /// Removes a column from a table.
    ///
    /// ## Examples
    /// * `DROP COLUMN language_code`
    ///
    /// - parameter column: The column to remove from the table.
    static func DROP_COLUMN(_ column: AnyColumn) -> Segment {
        .clause(
            keyword: .compound(.drop, .column),
            segments: [
                Segment.column(column)
            ]
        )
    }
}
