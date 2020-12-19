import Foundation

class LogicalRenderer {
    let `operator`: LogicalOperator
    let separator: String
    private var components: [String] = []
    
    init(_ op: LogicalOperator) {
        self.operator = op
        self.separator = " \(op.operator) "
    }
    
    func render() -> String {
        components.joined(separator: separator)
    }
}

extension LogicalRenderer: Renderer {
    func addRaw(_ text: String) {
        components.append(text)
    }
    
    func addClause<C>(_ clause: Clause<C>) {
        components.append(clause.render())
    }
    
    func addPredicate<C>(_ predicate: Predicate<C>) {
        components.append(predicate.render())
    }
    
    func addLogicalPredicate<C>(_ logicalPredicate: LogicalPredicate<C>) {
        components.append(logicalPredicate.render())
    }
    
    func addGroup<C>(_ group: Group<C>) {
        components.append(group.render())
    }
}