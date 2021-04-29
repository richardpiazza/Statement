import Statement

public extension SQLiteStatement {
    enum JoinContext {}
}

public extension Clause where Context == SQLiteStatement.StatementContext {
    static func JOIN(_ segments: Segment<SQLiteStatement.JoinContext>...) -> Clause {
        Clause(keyword: .join, segments: segments)
    }
}

public extension Clause where Context == SQLiteStatement.StatementContext {
    /// Shortcut for
    /// ```
    /// .JOIN(
    ///     .table(Table.self),
    ///     .ON(Column1, Column2)
    /// )
    /// ```
    @available(*, deprecated, message: "Use FROM(.JOIN())")
    static func JOIN_TABLE<T: Table>(_ type: T.Type, on c1: AnyColumn, equals c2: AnyColumn) -> Clause {
        return Clause(keyword: .join, segments: [
            Segment.table(type),
            Segment.ON(c1, c2)
        ])
    }
}

public extension Segment where Context == SQLiteStatement.JoinContext {
    @available(*, deprecated, message: "Use Segment.comparison()")
    static func ON(_ c1: AnyColumn, _ c2: AnyColumn) -> Segment {
        .clause(
            Clause<SQLiteStatement.JoinContext>(
                keyword: .on,
                segments: [
                    Segment.column(c1, tablePrefix: true),
                    Segment.column(c2, tablePrefix: true)
                ],
                separator: " = "
            )
        )
    }
}
