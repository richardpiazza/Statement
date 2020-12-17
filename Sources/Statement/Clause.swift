import Foundation

struct Clause<Context> {
    var keyword: Keyword
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
        Clause(keyword: .select, elements: elements)
    }
    
    static func FROM(_ elements: Element<SQLiteStatement.FromContext>...) -> Clause {
        Clause(keyword: .from, elements: elements)
    }
    
    static func JOIN(_ elements: Element<SQLiteStatement.JoinContext>...) -> Clause {
        Clause(keyword: .join, elements: elements)
    }
    
    static func WHERE(_ elements: Element<SQLiteStatement.WhereContext>...) -> Clause {
        Clause(keyword: .where, elements: elements)
    }
    
    static func UPDATE(_ elements: Element<SQLiteStatement.UpdateContext>...) -> Clause {
        Clause(keyword: .update, elements: elements)
    }
    
    static func SET(_ elements: Element<SQLiteStatement.SetContext>...) -> Clause {
        Clause(keyword: .set, elements: elements)
    }
}
