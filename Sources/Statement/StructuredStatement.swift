import Foundation

public struct StructuredStatement<Syntax: StatementSyntax> {
    public var clauses: [Clause<Syntax.StatementContext>]
    private let separator: String = "\n"
    
    public init(clauses: [Clause<Syntax.StatementContext>]) {
        self.clauses = clauses
    }
}

public extension StructuredStatement {
    func render() -> String {
        clauses.map { $0.render() }.joined(separator: separator)
    }
}
