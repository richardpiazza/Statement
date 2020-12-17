import Foundation

struct Clause<Context> {
    var keyword: Keyword<Context>
    var elements: [AnyElement]
}

extension Clause {
    func render() -> String {
        let renderer = ClauseRenderer(keyword)
        elements.forEach { $0.render(into: renderer) }
        return renderer.render()
    }
}

extension Clause where Context == SQLiteStatement.StatementContext {
    static func SELECT(_ elements: Element<SQLiteStatement.SelectContext>...) -> Clause {
        Clause(
            keyword: .SELECT,
            elements: elements
        )
    }
    
    static func FROM(_ elements: Element<SQLiteStatement.FromContext>...) -> Clause {
        Clause(
            keyword: .FROM,
            elements: elements
        )
    }
    
    static func JOIN(_ elements: Element<SQLiteStatement.JoinContext>...) -> Clause {
        Clause(
            keyword: .JOIN,
            elements: elements
        )
    }
    
    static func WHERE(_ elements: Element<SQLiteStatement.WhereContext>...) -> Clause {
        Clause(
            keyword: .WHERE,
            elements: elements
        )
    }
}
