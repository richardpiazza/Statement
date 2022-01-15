import Statement

public extension SQLiteStatement {
    enum FromContext {}
}

public extension Clause where Context == SQLiteStatement.StatementContext {
    static func FROM(_ segments: Segment<SQLiteStatement.FromContext>...) -> Clause {
        Clause(keyword: .from, segments: segments)
    }
}

public extension Segment where Context == SQLiteStatement.FromContext {
    static func TABLE<E: Entity>(_ type: E.Type) -> Segment {
        .entity(type)
    }
    
    static func TABLE(_ entity: Entity) -> Segment {
        .entity(entity)
    }
    
    /// Perform a SQL 'JOIN'
    ///
    /// The following **Statement** syntax:
    /// ```swift
    /// .FROM(
    ///     .TABLE(FirstEntity.self),
    ///     .JOIN_ON(SecondEntity.self, attribute: SecondEntityAttribute(), equals: FirstEntity.self, attribute: FirstEntityAttribute())
    /// )
    /// ```
    /// Produces the SQL:
    /// ```sql
    /// FROM first_entity JOIN second_entity ON second_entity.attribute = first_entity.attribute
    /// ```
    ///
    /// - parameters:
    ///   - e1: The `Entity` type that is being joined with the existing statement.
    ///   - a1: The `Attribute` of the entity being joined used for comparison.
    ///   - e2: The `Entity` type prexisting in the statement.
    ///   - a2: The `Attribute` of the entity used to compare with joining.
    static func JOIN_ON<E: Entity, J: Entity>(_ e1: E.Type, attribute a1: Attribute, equals e2: J.Type, attribute a2: Attribute) -> Segment {
        .clause(keyword: .join, segments: [
            Segment<Context>.entity(e1),
            .keyword(.on),
            .comparison(op: .equal, segments: [
                Segment<Context>.column(e1, attribute: a1),
                .column(e2, attribute: a2)
            ])
        ])
    }
    
    /// Perform a SQL 'JOIN'
    ///
    /// The following **Statement** syntax:
    /// ```swift
    /// .FROM(
    ///     .TABLE(FirstEntity.self),
    ///     .JOIN_ON(SecondEntity(), attribute: SecondEntityAttribute(), equals: FirstEntity(), attribute: FirstEntityAttribute())
    /// )
    /// ```
    /// Produces the SQL:
    /// ```sql
    /// FROM first_entity JOIN second_entity ON second_entity.attribute = first_entity.attribute
    /// ```
    ///
    /// - parameters:
    ///   - e1: The `Entity` that is being joined with the existing statement.
    ///   - a1: The `Attribute` of the entity being joined used for comparison.
    ///   - e2: The `Entity` prexisting in the statement.
    ///   - a2: The `Attribute` of the entity used to compare with joining.
    static func JOIN_ON(_ e1: Entity, attribute a1: Attribute, equals e2: Entity, attribute a2: Attribute) -> Segment {
        .clause(keyword: .join, segments: [
            Segment<Context>.entity(e1),
            .keyword(.on),
            .comparison(op: .equal, segments: [
                Segment<Context>.column(a1, entity: e1),
                .column(a2, entity: e2)
            ])
        ])
    }
}

public extension Clause where Context == SQLiteStatement.StatementContext {
    /// A convenience for
    /// ```
    /// .FROM(
    ///     .TABLE(type)
    /// )
    /// ```
    static func FROM_TABLE<E: Entity>(_ type: E.Type) -> Clause {
        .FROM(
            .TABLE(type)
        )
    }
    
    static func FROM_TABLE(_ entity: Entity) -> Clause {
        .FROM(
            .TABLE(entity)
        )
    }
}
