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
    
    static func FROM<T: Table>(_ table: T.Type, _ segments: Segment<SQLiteStatement.FromContext>...) -> Clause {
        let tab = Segment<Context>.table(table)
        var allSegments: [AnyRenderable] = [tab]
        allSegments.append(contentsOf: segments)
        return Clause(keyword: .from, segments: allSegments)
    }
    
    static func JOIN(_ segments: Segment<SQLiteStatement.JoinContext>...) -> Clause {
        return Clause(keyword: .join, segments: segments)
    }
    
    static func WHERE(_ segments: Segment<SQLiteStatement.WhereContext>...) -> Clause {
        Clause(keyword: .where, segments: segments)
    }
    
    static func LIMIT(_ limit: Int) -> Clause {
        Clause(keyword: .limit, segments: [
            Segment<Context>.limit(limit)
        ])
    }
    
    static func UPDATE(_ segments: Segment<SQLiteStatement.UpdateContext>...) -> Clause {
        Clause(keyword: .update, segments: segments)
    }
    
    static func UPDATE<T: Table>(_ table: T.Type, _ segments: Segment<SQLiteStatement.UpdateContext>...) -> Clause {
        let tab = Segment<Context>.table(table)
        var allSegments: [AnyRenderable] = [tab]
        allSegments.append(contentsOf: segments)
        return Clause(keyword: .update, segments: allSegments)
    }
    
    static func SET(_ segments: Segment<SQLiteStatement.SetContext>...) -> Clause {
        Clause(keyword: .set, segments: segments, separator: ", ")
    }
    
    static func INSERT_INTO<T: Table>(_ table: T.Type, _ segments: Segment<SQLiteStatement.InsertIntoContext>...) -> Clause {
        let tab = Segment<Context>.table(table)
        let group = Group<Context>(segments: segments)
        let into = Clause(keyword: .into, segments: [tab, group])
        return Clause(keyword: .insert, segments: [
            Segment.clause(into)
        ])
    }
    
    static func VALUES(_ segments: Segment<SQLiteStatement.ValuesContext>...) -> Clause {
        let group = Group<Context>(segments: segments)
        return Clause(keyword: .values, segments: [
            Segment.group(group)
        ])
    }
}
