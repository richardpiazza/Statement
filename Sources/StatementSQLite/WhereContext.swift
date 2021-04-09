import Statement

public extension SQLiteStatement {
    enum WhereContext {}
}

public extension Segment where Context == SQLiteStatement.WhereContext {
    static func AND(_ segments: Segment<Context>...) -> Segment {
        .logicalPredicate(
            LogicalPredicate(.and, elements: segments)
        )
    }
}
