import Foundation

enum Segment<Context> {
    case raw(String)
    case clause(Clause<Context>)
    case predicate(Predicate<Context>)
    case logicalPredicate(LogicalPredicate<Context>)
    case group(Group<Context>)
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
