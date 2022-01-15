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
    static func TABLE<E: Entity>(_ type: E.Type, ifNotExists: Bool = true, segments: Segment<Context>...) -> Segment {
        .clause(
            Clause(
                keyword: .table,
                segments: [
                    Segment.if(ifNotExists, .keyword(.compound(.if, .not, .exists))),
                    Segment.entity(type),
                    Group<Context>(segments: segments, separator: ",\n")
                ]
            )
        )
    }
    
    static func TABLE(_ entity: Entity, ifNotExists: Bool = true, segments: Segment<Context>...) -> Segment {
        .clause(
            Clause(
                keyword: .table,
                segments: [
                    Segment.if(ifNotExists, .keyword(.compound(.if, .not, .exists))),
                    Segment.entity(entity),
                    Group<Context>(segments: segments, separator: ",\n")
                ]
            )
        )
    }
    
    static func COLUMN(_ attribute: Attribute, segments: Segment<Context>...) -> Segment {
        .clause(
            Clause(
                keyword: Keyword(stringLiteral: "\(attribute.identifier)"),
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
    
    static func PRIMARY_KEY(_ attribute: Attribute) -> Segment {
        .clause(
            Clause(
                keyword: .compound(.primary, .key),
                segments: [
                    Segment.group(
                        Group<Context>(
                            segments: [
                                Segment.raw(attribute.identifier),
                                Segment.if(attribute.autoIncrement, .keyword(.autoIncrement))
                            ],
                            separator: " "
                        )
                    )
                ]
            )
        )
    }
    
    static func FOREIGN_KEY(_ attribute: Attribute, references reference: ForeignKey) -> Segment {
        .clause(
            Clause(
                keyword: .compound(.foreign, .key),
                segments: [
                    Segment.group(
                        Group<Context>(
                            segments: [
                                Segment.raw(attribute.identifier)
                            ]
                        )
                    ),
                    .keyword(.references),
                    .raw(reference.entity.identifier),
                    .group(Group<Context>(segments: [
                        Segment.raw(reference.attribute.identifier)
                    ]))
                ]
            )
        )
    }
}

// MARK: - Compound Statements
public extension Segment where Context == SQLiteStatement.CreateContext {
    /// Initializes a single table (`Entity`) schema.
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
    static func SCHEMA(_ entity: Entity, ifNotExists: Bool = true, segments: Segment<Context>...) -> Segment {
        var allSegments: [Segment] = []
        allSegments.append(Segment.if(ifNotExists, .keyword(.compound(.if, .not, .exists))))
        allSegments.append(Segment.entity(entity))
        
        var columnSegments = entity.attributes.map { COLUMN($0) }
        
        entity.attributes.filter({ $0.primaryKey }).forEach { (column) in
            let segment = PRIMARY_KEY(column)
            columnSegments.append(segment)
        }
        
        entity.attributes.filter({ $0.foreignKey != nil }).forEach { (column) in
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
