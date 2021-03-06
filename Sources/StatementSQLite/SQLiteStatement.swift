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
