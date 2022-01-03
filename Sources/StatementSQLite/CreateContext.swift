import Statement

public extension SQLiteStatement {
    enum CreateContext {}
}

public extension Clause where Context == SQLiteStatement.StatementContext {
    static func CREATE(_ segments: Segment<SQLiteStatement.CreateContext>...) -> Clause {
        Clause(keyword: .create, segments: segments)
    }
}

public extension Segment where Context == SQLiteStatement.CreateContext {
    @available(*, deprecated)
    static func TABLE<T: Table>(_ type: T.Type, ifNotExists: Bool = true, segments: Segment<Context>...) -> Segment {
        .clause(
            Clause(
                keyword: .table,
                segments: [
                    Segment.if(ifNotExists, .keyword(.compound(.if, .not, .exists))),
                    Segment.table(type),
                    Group<Context>(segments: segments, separator: ",\n")
                ]
            )
        )
    }
    
    static func TABLE(_ table: Entity, ifNotExists: Bool = true, segments: Segment<Context>...) -> Segment {
        .clause(
            Clause(
                keyword: .table,
                segments: [
                    Segment.if(ifNotExists, .keyword(.compound(.if, .not, .exists))),
                    Segment.entity(table),
                    Group<Context>(segments: segments, separator: ",\n")
                ]
            )
        )
    }
    
    @available(*, deprecated)
    static func COLUMN(_ column: AnyColumn, segments: Segment<Context>...) -> Segment {
        .clause(
            Clause(
                keyword: Keyword(stringLiteral: "\(column.name)"),
                segments: [
                    Segment.raw(column.dataType),
                    .if(column.notNull, .keyword(.compound(.not, .null))),
                    .if(column.unique, .keyword(.unique)),
                    .unwrap(column.defaultValue, transform: { .raw("\(Keyword.default.rawValue) \($0.sqlArgument())") })
                ]
            )
        )
    }
    
    static func COLUMN(_ attribute: Attribute, segments: Segment<Context>...) -> Segment {
        .clause(
            Clause(
                keyword: Keyword(stringLiteral: "\(attribute.columnName)"),
                segments: [
                    Segment.raw(attribute.dataType.sqliteDataType),
                    .if(attribute.notNull, .keyword(.compound(.not, .null))),
                    .if(attribute.unique, .keyword(.unique)),
                    .unwrap(attribute.defaultValue, transform: {
                        .raw("\(Keyword.default.rawValue) \($0.sqliteArgument)")
                    })
                ]
            )
        )
    }
    
    @available(*, deprecated)
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
    
    static func PRIMARY_KEY(_ column: Attribute) -> Segment {
        .clause(
            Clause(
                keyword: .compound(.primary, .key),
                segments: [
                    Segment.group(
                        Group<Context>(
                            segments: [
                                Segment.raw(column.columnName),
                                Segment.if(column.autoIncrement, .keyword(.autoIncrement))
                            ],
                            separator: " "
                        )
                    )
                ]
            )
        )
    }
    
    @available(*, deprecated)
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
    
    static func FOREIGN_KEY(_ column: Attribute, references reference: ForeignKey) -> Segment {
        .clause(
            Clause(
                keyword: .compound(.foreign, .key),
                segments: [
                    Segment.group(
                        Group<Context>(
                            segments: [
                                Segment.raw(column.columnName)
                            ]
                        )
                    ),
                    .keyword(.references),
                    .raw(reference.entity.tableName),
                    .group(Group<Context>(segments: [
                        Segment.raw(reference.attribute.columnName)
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
    @available(*, deprecated)
    static func SCHEMA<T: Table>(_ type: T.Type, ifNotExists: Bool = true, segments: Segment<Context>...) -> Segment {
        var allSegments: [Segment] = []
        allSegments.append(Segment.if(ifNotExists, .keyword(.compound(.if, .not, .exists))))
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
    
    static func SCHEMA<E: Entity>(_ type: E.Type, ifNotExists: Bool = true, segments: Segment<Context>...) -> Segment {
        return SCHEMA(E.init(), ifNotExists: ifNotExists, segments: segments)
    }
    
    static func SCHEMA(_ table: Entity, ifNotExists: Bool = true, segments: [Segment<Context>]) -> Segment {
        var allSegments: [Segment] = []
        allSegments.append(Segment.if(ifNotExists, .keyword(.compound(.if, .not, .exists))))
        allSegments.append(Segment.entity(table))
        
        var columnSegments = table.attributes.map { COLUMN($0) }
        
        table.attributes.filter({ $0.primaryKey }).forEach { (column) in
            let segment = PRIMARY_KEY(column)
            columnSegments.append(segment)
        }
        
        table.attributes.filter({ $0.foreignKey != nil }).forEach { (column) in
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
