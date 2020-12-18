import Foundation

class ClauseRenderer {
    let keyword: Keyword
    let separator: String
    private var components: [String] = []
    
    init(_ keyword: Keyword, separator: String) {
        self.keyword = keyword
        self.separator = separator
    }
    
    func render() -> String {
        keyword.value + " " + components.joined(separator: separator)
    }
}

extension ClauseRenderer: Renderer {
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
