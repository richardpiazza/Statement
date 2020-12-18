import Foundation

struct Clause<Context> {
    var keyword: Keyword
    var segments: [AnyRenderable]
    var separator: String = " "
}

extension Clause {
    func render() -> String {
        let renderer = ClauseRenderer(keyword, separator: separator)
        segments.forEach { $0.render(into: renderer) }
        return renderer.render()
    }
}

extension Clause where Context == SQLiteStatement.StatementContext {
    static func SELECT(_ segments: Segment<SQLiteStatement.SelectContext>...) -> Clause {
        Clause(keyword: .select, segments: segments, separator: ", ")
    }
    
    static func FROM(_ segments: Segment<SQLiteStatement.FromContext>...) -> Clause {
        Clause(keyword: .from, segments: segments)
    }
    
    static func JOIN(_ segments: Segment<SQLiteStatement.JoinContext>...) -> Clause {
        return Clause(keyword: .join, segments: segments)
    }
    
    static func WHERE(_ segments: Segment<SQLiteStatement.WhereContext>...) -> Clause {
        Clause(keyword: .where, segments: segments)
    }
    
    static func LIMIT(_ limit: Int) -> Clause {
        Clause(keyword: .limit, segments: [
            Segment<Context>.identifier("\(limit)")
        ])
    }
    
    static func UPDATE(_ segments: Segment<SQLiteStatement.UpdateContext>...) -> Clause {
        Clause(keyword: .update, segments: segments)
    }
    
    static func SET(_ segments: Segment<SQLiteStatement.SetContext>...) -> Clause {
        Clause(keyword: .set, segments: segments, separator: ", ")
    }
}
