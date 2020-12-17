import Foundation

struct Statement<Syntax: StatementSyntax> {
    var clauses: [Clause<Syntax.StatementContext>]
}

extension Statement {
    func render() -> String {
        clauses.map { $0.render() }.joined(separator: "\n")
    }
}
