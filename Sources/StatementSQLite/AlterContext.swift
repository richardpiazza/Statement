import Statement

public extension SQLiteStatement {
    enum AlterContext {}
}

public extension Clause where Context == SQLiteStatement.StatementContext {
    static func ALTER(_ segments: Segment<SQLiteStatement.AlterContext>...) -> Clause {
        Clause(keyword: .alter, segments: segments)
    }
    
    /// Change a single table.
    ///
    /// This is a shorthand for supplying the 'TABLE' keyword and the name variable.
    /// ```
    /// (
    ///     .keyword(.alter),
    ///     .keyword(.table),
    ///     .table(Table.self),
    ///     ...
    /// )
    /// ```
    static func ALTER_TABLE<T: Table>(_ type: T.Type, _ segments: Segment<SQLiteStatement.AlterContext>...) -> Clause {
        var clauseSegments = segments
        clauseSegments.insert(.table(type), at: 0)
        return Clause(keyword: .compound(.alter, .table), segments: clauseSegments)
    }
}

public extension Clause where Context == SQLiteStatement.AlterContext {
}

public extension Segment where Context == SQLiteStatement.AlterContext {
    /// Changes the name of the table.
    ///
    /// This is shorthand for supplying the `RENAME`/`TO` keywords and the new name.
    /// ```swift
    /// (
    ///     .keyword(.rename),
    ///     .keyword(.to),
    ///     .table(Table.self)
    /// )
    /// ```
    static func RENAME_TO<T: Table>(_ type: T.Type) -> Segment {
        .clause(
            Clause(
                keyword: .compound(.rename, .to),
                segments: [
                    Segment.table(type)
                ]
            )
        )
    }
    
    /// Rename a specific column of a table.
    ///
    /// Shorthand for:
    /// ```swift
    /// (
    ///     .keyword(.rename),
    ///     .keyword(.column),
    ///     .column(originalColumn),
    ///     .keyword(.to),
    ///     .column(newColumn)
    /// )
    /// ```
    static func RENAME_COLUMN(_ column: AnyColumn, to: AnyColumn) -> Segment {
        .clause(
            Clause(
                keyword: .compound(.rename, .column),
                segments: [
                    Segment.column(column),
                    Segment.keyword(.to),
                    Segment.column(to)
                ]
            )
        )
    }
    
    /// Add a column to the end of a table.
    ///
    /// Shorthand for:
    /// ```swift
    /// (
    ///     .keyword(.add),
    ///     .keyword(.column),
    ///     .column(column),
    ///     .raw(column.dataType),
    ///     // Not Null?
    ///     // Unique?
    ///     // Default Value
    /// )
    /// ```
    static func ADD_COLUMN(_ column: AnyColumn) -> Segment {
        .clause(
            Clause(
                keyword: .compound(.add, .column),
                segments: [
                    Segment.column(column),
                    Segment.raw(column.dataType),
                    .if(column.notNull, .keyword(.compound(.not, .null))),
                    .if(column.unique, .keyword(.unique)),
                    .unwrap(column.defaultValue, transform: { .raw("\(Keyword.default.value) \($0.sqlArgument())") })
                ]
            )
        )
    }
    
    /// Removes a column from a table.
    ///
    /// Shorthand for:
    /// ```swift
    /// (
    ///     .keyword(.drop),
    ///     .keyword(.column),
    ///     .column(column)
    /// )
    /// ```
    static func DROP_COLUMN(_ column: AnyColumn) -> Segment {
        .clause(
            Clause(
                keyword: .compound(.drop, .column),
                segments: [
                    Segment.column(column)
                ]
            )
        )
    }
}
