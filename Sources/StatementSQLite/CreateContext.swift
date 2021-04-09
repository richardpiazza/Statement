import Statement

public extension SQLiteStatement {
    enum CreateContext {}
}

public extension Segment where Context == SQLiteStatement.CreateContext {
    static func TABLE<T: Table>(_ type: T.Type, ifNotExists: Bool = true, segments: Segment<Context>...) -> Segment {
        .clause(
            Clause(
                keyword: .table,
                segments: [
                    Segment.if(ifNotExists, .raw("IF NOT EXISTS")),
                    Segment.table(type),
                    Group<Context>(segments: segments, separator: ",\n")
                ]
            )
        )
    }
    
    static func COLUMN(_ column: AnyColumn, segments: Segment<Context>...) -> Segment {
        .clause(
            Clause(
                keyword: Keyword(stringLiteral: "\(column.name)"),
                segments: [
                    Segment.raw(column.dataType),
                    .if(column.notNull, .raw("NOT NULL")),
                    .if(column.unique, .raw("UNIQUE")),
                    .unwrap(column.defaultValue, transform: { .raw("DEFAULT \($0.sqlArgument())") })
                ]
            )
        )
    }
    
    static func PRIMARY_KEY(_ column: AnyColumn) -> Segment {
        .clause(
            Clause(
                keyword: .compound(.primary, .key),
                segments: [
                    Segment.group(
                        Group<Context>(
                            segments: [
                                Segment.raw(column.name),
                                Segment.if(column.autoIncrement, .keyword(.autoIncrement))
                            ],
                            separator: " "
                        )
                    )
                ]
            )
        )
    }
    
    static func FOREIGN_KEY(_ column: AnyColumn, references reference: AnyColumn) -> Segment {
        .clause(
            Clause(
                keyword: .compound(.foreign, .key),
                segments: [
                    Segment.group(
                        Group<Context>(
                            segments: [
                                Segment.raw(column.name)
                            ]
                        )
                    ),
                    .keyword(.references),
                    .raw(reference.table.schema.name),
                    .group(Group<Context>(segments: [
                        Segment.raw(reference.name)
                    ]))
                ]
            )
        )
    }
}

// MARK: - Compound Statements
public extension Segment where Context == SQLiteStatement.CreateContext {
    /// Initializes a single table schema.
    ///
    /// Equivalent to
    ///
    /// ```
    /// .TABLE(
    ///   Translation.self,
    ///   ifNotExists: true,
    ///   segments:
    ///   .COLUMN(Translation.CodingKeys.id, dataType: .integer, notNull: true, unique: true),
    ///   .COLUMN(Translation.CodingKeys.expressionID, dataType: .integer, notNull: true),
    ///   .COLUMN(Translation.CodingKeys.language, dataType: .text, notNull: true),
    ///   .COLUMN(Translation.CodingKeys.region, dataType: .text),
    ///   .COLUMN(Translation.CodingKeys.value, dataType: .text, notNull: true),
    ///   .PRIMARY_KEY(Translation.CodingKeys.id, autoIncrement: true),
    ///   .FOREIGN_KEY(Translation.CodingKeys.expressionID, references: Expression.CodingKeys.id)
    /// )
    /// ```
    static func SCHEMA<T: Table>(_ type: T.Type, ifNotExists: Bool = true, segments: Segment<Context>...) -> Segment {
        var allSegments: [Segment] = []
        allSegments.append(Segment.if(ifNotExists, .raw("IF NOT EXISTS")))
        allSegments.append(Segment.table(type))
        
        var columnSegments = type.schema.columns.map { COLUMN($0) }
        
        type.schema.columns.filter({ $0.primaryKey }).forEach { (column) in
            let segment = PRIMARY_KEY(column)
            columnSegments.append(segment)
        }
        
        type.schema.columns.filter({ $0.foreignKey != nil }).forEach { (column) in
            let segment = FOREIGN_KEY(column, references: column.foreignKey!)
            columnSegments.append(segment)
        }
        
        allSegments.append(.group(Group(segments: columnSegments, separator: ",\n")))
        
        return .clause(
            Clause(
                keyword: .table,
                segments: allSegments
            )
        )
    }
}
