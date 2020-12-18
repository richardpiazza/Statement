import Foundation

class GroupRenderer {
    let prefix: String
    let suffix: String
    let separator: String
    private var components: [String] = []
    
    init(prefix: String, suffix: String, separator: String) {
        self.prefix = prefix
        self.suffix = suffix
        self.separator = separator
    }
    
    func render() -> String {
        return prefix + " " + components.joined(separator: separator) + " " + suffix
    }
}

extension GroupRenderer: Renderer {
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
