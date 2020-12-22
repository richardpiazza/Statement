import Statement

public extension Segment where Context == SQLiteStatement.JoinContext {
    static func ON(_ c1: AnyColumn, _ c2: AnyColumn) -> Segment {
        .clause(
            Clause<SQLiteStatement.JoinContext>(
                keyword: .on,
                segments: [
                    Segment.column(c1),
                    Segment.column(c2)
                ],
                separator: " = "
            )
        )
    }
}

public extension Segment where Context == SQLiteStatement.WhereContext {
    static func AND(_ segments: Segment<Context>...) -> Segment {
        .logicalPredicate(
            LogicalPredicate(.and, elements: segments)
        )
    }
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
    
    static func COLUMN(_ column: AnyColumn, dataType: String, segments: Segment<Context>...) -> Segment {
        .clause(
            Clause(
                keyword: Keyword(stringLiteral: "\(column.name)"),
                segments: [
                    Segment.raw(dataType),
                    .if(column.notNull, .raw("NOT NULL")),
                    .if(column.unique, .raw("UNIQUE"))
                ]
            )
        )
    }
    
    static func PRIMARY_KEY(_ column: AnyColumn, autoIncrement: Bool = true) -> Segment {
        .clause(
            Clause(
                keyword: .primary,
                segments: [
                    Segment.clause(
                        Clause(
                            keyword: .key,
                            segments: [
                                Segment.group(Group<Context>(segments: [
                                    Segment.raw(column.name),
                                    Segment.if(autoIncrement, .keyword(.autoIncrement))
                                ]))
                            ]
                        )
                    )
                ]
            )
        )
    }
    
    static func FOREIGN_KEY(_ column: AnyColumn, references reference: AnyColumn) -> Segment {
        .clause(
            Clause(
                keyword: .foreign,
                segments: [
                    Segment.clause(
                        Clause(
                            keyword: .key,
                            segments: [
                                Segment.group(Group<Context>(segments: [
                                    Segment.raw(column.name)
                                ]))
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

// MARK: - Convenience
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
        
        var columnSegments = type.schema.columns.map { schemaColumn($0) }
        
        type.schema.columns.filter({ $0.primaryKey }).forEach { (column) in
            let segment = primaryKeyColumn(column)
            columnSegments.append(segment)
        }
        
        type.schema.columns.filter({ $0.foreignKey != nil }).forEach { (column) in
            let segment = foreignKeyColumn(column)
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
    
    /// A column initializer
    private static func schemaColumn(_ column: AnyColumn) -> Segment {
        let dataType: String
        switch column {
        case is Column<Int>, is Column<Int?>:
            dataType = "INTEGER"
        case is Column<Double>, is Column<Double?>:
            dataType = "REAL"
        default:
            dataType = "TEXT"
        }
        
        return .clause(
            Clause(
                keyword: Keyword(stringLiteral: "\(column.name)"),
                segments: [
                    Segment.raw(dataType),
                    .if(column.notNull, .raw("NOT NULL")),
                    .if(column.unique, .raw("UNIQUE")),
                    .unwrap(column.defaultValue, transform: { .raw("DEFAULT \($0.sqlString)") })
                ]
            )
        )
    }
    
    private static func primaryKeyColumn(_ column: AnyColumn) -> Segment {
        .clause(
            Clause(
                keyword: .primary,
                segments: [
                    Segment.clause(
                        Clause(
                            keyword: .key,
                            segments: [
                                Segment.group(Group<Context>(segments: [
                                    Segment.raw(column.name),
                                    Segment.if(column.autoIncrement, .keyword(.autoIncrement))
                                ]))
                            ]
                        )
                    )
                ]
            )
        )
    }
    
    private static func foreignKeyColumn(_ column: AnyColumn) -> Segment {
        .clause(
            Clause(
                keyword: .foreign,
                segments: [
                    Segment.clause(
                        Clause(
                            keyword: .key,
                            segments: [
                                Segment.group(Group<Context>(segments: [
                                    Segment.raw(column.name)
                                ]))
                            ]
                        )
                    ),
                    .keyword(.references),
                    .raw(column.foreignKey!.table.schema.name),
                    .group(Group<Context>(segments: [
                        Segment.raw(column.foreignKey!.name)
                    ]))
                ]
            )
        )
    }
}
