import Statement

public extension Clause where Context == SQLiteStatement.StatementContext {
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
            Segment<Context>.limit(limit)
        ])
    }
    
    static func UPDATE(_ segments: Segment<SQLiteStatement.UpdateContext>...) -> Clause {
        Clause(keyword: .update, segments: segments)
    }
    
    static func SET(_ segments: Segment<SQLiteStatement.SetContext>...) -> Clause {
        Clause(keyword: .set, segments: segments, separator: ", ")
    }
    
    static func INSERT_INTO<T: Table>(_ type: T.Type, _ segments: Segment<SQLiteStatement.InsertIntoContext>...) -> Clause {
        let table = Segment<Context>.table(type)
        let group = Group<Context>(segments: segments)
        let into = Clause(keyword: .into, segments: [table, group])
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
    
    static func CREATE(_ segments: Segment<SQLiteStatement.CreateContext>...) -> Clause {
        return Clause(keyword: .create, segments: segments)
    }
}

// MARK: - Conveniences
public extension Clause where Context == SQLiteStatement.StatementContext {
    /// A convenience for
    /// ```
    /// .FROM(
    ///     .table(Table.self),
    ///     ...
    /// )
    /// ```
    static func FROM<T: Table>(_ type: T.Type, _ segments: Segment<SQLiteStatement.FromContext>...) -> Clause {
        let table = Segment<Context>.table(type)
        var allSegments: [AnyRenderable] = [table]
        allSegments.append(contentsOf: segments)
        return Clause(keyword: .from, segments: allSegments)
    }
    
    /// Shortcut for
    /// ```
    /// .JOIN(
    ///     .table(Table.self),
    ///     .ON(Column1, Column2)
    /// )
    /// ```
    static func JOIN<T: Table>(_ type: T.Type, on c1: AnyColumn, equals c2: AnyColumn) -> Clause {
        return Clause(keyword: .join, segments: [
            Segment.table(type),
            Segment.ON(c1, c2)
        ])
    }
    
    /// A convenience for
    /// ```
    /// .UPDATE(
    ///     .table(Table.self),
    ///     ...
    /// )
    /// ```
    static func UPDATE<T: Table>(_ type: T.Type, _ segments: Segment<SQLiteStatement.UpdateContext>...) -> Clause {
        let table = Segment<Context>.table(type)
        var allSegments: [AnyRenderable] = [table]
        allSegments.append(contentsOf: segments)
        return Clause(keyword: .update, segments: allSegments)
    }
}
