import Foundation

enum Segment<Context> {
    case keyword(Keyword)
    case identifier(String)
    case clause(Clause<Context>)
    case predicate(Predicate<Context>)
    case logicalPredicate(LogicalPredicate<Context>)
}

extension Segment: AnyRenderable {
    func render(into renderer: Renderer) {
        switch self {
        case .keyword(let keyword):
            renderer.addRaw(keyword.value)
        case .identifier(let identifier):
            renderer.addRaw(identifier)
        case .clause(let clause):
            renderer.addRaw(clause.render())
        case .predicate(let predicate):
            predicate.render(into: renderer)
        case .logicalPredicate(let predicate):
            renderer.addRaw(predicate.render())
        }
    }
}

extension Segment {
    static func column(_ column: Column) -> Self {
        let id = "\(type(of: column).tableName).\(column.stringValue)"
        return .identifier(id)
    }
    
    static func table<T: Table>(_ table: T.Type) -> Self {
        let id = table.schema.name
        return .identifier(id)
    }
    
    static func expression(_ column: Column, _ op: ComparisonOperator) -> Self {
        let predicate = Predicate<Context>(column, op)
        return .predicate(predicate)
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
