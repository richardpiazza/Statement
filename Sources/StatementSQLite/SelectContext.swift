import Statement

public extension SQLiteStatement {
    enum SelectContext {}
}

public extension Segment where Context == SQLiteStatement.SelectContext {
    
}
