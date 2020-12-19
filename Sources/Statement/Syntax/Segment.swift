import Foundation

enum Segment<Context> {
    case raw(String)
    case clause(Clause<Context>)
    case predicate(Predicate<Context>)
    case logicalPredicate(LogicalPredicate<Context>)
    case group(Group<Context>)
    case empty
}

extension Segment: AnyRenderable {
    func render(into renderer: Renderer) {
        switch self {
        case .raw(let identifier):
            renderer.addRaw(identifier)
        case .clause(let clause):
            renderer.addClause(clause)
        case .predicate(let predicate):
            renderer.addPredicate(predicate)
        case .logicalPredicate(let predicate):
            renderer.addLogicalPredicate(predicate)
        case .group(let group):
            renderer.addGroup(group)
        case .empty:
            break
        }
    }
}

extension Segment {
    static func keyword(_ keyword: Keyword) -> Self {
        .raw(keyword.value)
    }
    
    static func column(_ column: Column) -> Self {
        let id = "\(type(of: column).tableName).\(column.stringValue)"
        return .raw(id)
    }
    
    static func table<T: Table>(_ table: T.Type) -> Self {
        let id = table.schema.name
        return .raw(id)
    }
    
    static func expression(_ column: Column, _ op: ComparisonOperator) -> Self {
        let predicate = Predicate<Context>(column, op)
        return .predicate(predicate)
    }
    
    static func limit(_ limit: Int) -> Self {
        .raw("\(limit)")
    }
    
    static func value(_ encodable: Encodable) -> Self {
        .raw(encodable.sqlString)
    }
}

extension Segment {
    static func `if`(_ condition: Bool, _ segment: Segment, else fallback: Segment? = nil) -> Segment {
        guard condition else {
            return fallback ?? .empty
        }
        
        return segment
    }
    
    static func unwrap<T>(_ optional: T?, transform: (T) throws -> Segment, else fallback: Segment = .empty) rethrows -> Segment {
        try optional.map(transform) ?? fallback
    }
    
    static func forEach<S: Sequence>(_ sequence: S, _ transform: (S.Element) throws -> Segment) rethrows -> Segment {
        try .group(Group(segments: sequence.map(transform)))
    }
}

extension Segment where Context == SQLiteStatement.JoinContext {
    static func ON(_ c1: Column, _ c2: Column) -> Segment {
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

extension Segment where Context == SQLiteStatement.WhereContext {
    static func AND(_ segments: Segment<Context>...) -> Segment {
        .logicalPredicate(
            LogicalPredicate(logicalOperator: .and, elements: segments)
        )
    }
}

extension Segment where Context == SQLiteStatement.CreateContext {
    static func TABLE<T: Table>(_ table: T.Type, ifNotExists: Bool = true, segments: Segment<Context>...) -> Segment {
        .clause(
            Clause(
                keyword: .table,
                segments: [
                    Segment.if(ifNotExists, .raw("IF NOT EXISTS")),
                    Segment.table(table),
                    Group<Context>(segments: segments, separator: ",\n")
                ]
            )
        )
    }
    
    static func COLUMN<C: Column>(
        _ column: C,
        dataType: SQLiteStatement.DataType,
        notNull: Bool = false,
        unique: Bool = false,
        segments: Segment<Context>...
    ) -> Segment {
        .clause(
            Clause(
                keyword: Keyword(stringLiteral: "\(column.stringValue)"),
                segments: [
                    Segment.raw(dataType.rawValue),
                    .if(notNull, .raw("NOT NULL")),
                    .if(unique, .raw("UNIQUE"))
                ]
            )
        )
    }
    
    static func PRIMARY_KEY(_ column: Column, autoIncrement: Bool = true) -> Segment {
        .clause(
            Clause(
                keyword: .primary,
                segments: [
                    Segment.clause(
                        Clause(
                            keyword: .key,
                            segments: [
                                Segment.group(Group<Context>(segments: [
                                    Segment.raw(column.stringValue),
                                    Segment.if(autoIncrement, .keyword(.autoIncrement))
                                ]))
                            ]
                        )
                    )
                ]
            )
        )
    }
    
    static func FOREIGN_KEY(_ column: Column, references reference: Column) -> Segment {
        .clause(
            Clause(
                keyword: .foreign,
                segments: [
                    Segment.clause(
                        Clause(
                            keyword: .key,
                            segments: [
                                Segment.group(Group<Context>(segments: [
                                    Segment.raw(column.stringValue)
                                ]))
                            ]
                        )
                    ),
                    .keyword(.references),
                    .raw(type(of: reference).tableName),
                    .group(Group<Context>(segments: [
                        Segment.raw(reference.stringValue)
                    ]))
                ]
            )
        )
    }
}
