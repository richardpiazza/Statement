import Foundation

struct SQLiteStatement: StatementSyntax {
    enum StatementContext {}
    
    enum DataType: String {
        case integer = "INTEGER"
        case real = "REAL"
        case text = "TEXT"
        case blob = "BLOB"
    }
    
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
    enum InsertIntoContext {}
    enum ValuesContext {}
    enum CreateContext {}
}
