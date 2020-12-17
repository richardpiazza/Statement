import Foundation

struct SQLiteStatement: StatementSyntax {
    enum StatementContext {}
    
    private let statement: Statement<SQLiteStatement>
    
    init(_ clauses: Clause<SQLiteStatement.StatementContext>...) {
        statement = Statement(clauses: clauses)
    }
}

extension SQLiteStatement {
    func render() -> String {
        statement.render() + ";"
    }
}

extension SQLiteStatement {
    enum SelectContext {}
    enum FromContext {}
    enum JoinContext {}
    enum WhereContext {}
    enum UpdateContext {}
    enum SetContext {}
}
