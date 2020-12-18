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
    static func SELECT(_ elements: Element...) -> Clause {
        Clause(keyword: .select, elements: elements)
    }
    
    static func FROM(_ elements: Element...) -> Clause {
        Clause(keyword: .from, elements: elements)
    }
    
    static func JOIN(_ elements: Element...) -> Clause {
        Clause(keyword: .join, elements: elements)
    }
    
    static func WHERE(_ elements: Segment<SQLiteStatement.WhereContext>...) -> Clause {
        Clause(keyword: .where, elements: elements)
    }
    
    static func UPDATE(_ elements: Element...) -> Clause {
        Clause(keyword: .update, elements: elements)
    }
    
    static func SET(_ elements: Element...) -> Clause {
        Clause(keyword: .set, elements: elements)
    }
}

extension Segment where Context == SQLiteStatement.WhereContext {
    static func AND(_ elements: AnyElement...) -> Segment {
        .logicalPredicate(
            LogicalPredicate(logicalOperator: .and, elements: elements)
        )
    }
}
