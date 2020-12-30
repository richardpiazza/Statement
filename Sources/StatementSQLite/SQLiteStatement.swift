import Statement

public struct SQLiteStatement: StatementSyntax {
    public enum StatementContext {}
    
    private let statement: StructuredStatement<SQLiteStatement>
    private let terminator: String = ";"
    
    public init(_ clauses: Clause<SQLiteStatement.StatementContext>...) {
        statement = StructuredStatement(clauses: clauses)
    }
}

public extension SQLiteStatement {
    func render() -> String {
        statement.render() + terminator
    }
}

public extension SQLiteStatement {
    enum SelectContext {}
    enum FromContext {}
    enum JoinContext {}
    enum WhereContext {}
    enum UpdateContext {}
    enum SetContext {}
    enum InsertIntoContext {}
    enum ValuesContext {}
    enum CreateContext {}
    enum DeleteContext {}
    enum HavingContext {}
}
