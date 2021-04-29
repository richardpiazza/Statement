import Foundation

public protocol Renderer: AnyObject {
    var components: [String] { get set }
    func render() -> String
}

public extension Renderer {
    func addRaw(_ text: String) {
        components.append(text)
    }
    
    func addClause<C>(_ clause: Clause<C>) {
        components.append(clause.render())
    }
    
    func addComparisonPredicate<C>(_ predicate: ComparisonPredicate<C>) {
        components.append(predicate.render())
    }
    
    func addLogicalPredicate<C>(_ predicate: LogicalPredicate<C>) {
        components.append(predicate.render())
    }
    
    func addConjunctivePredicate<C>(_ predicate: ConjunctivePredicate<C>) {
        components.append(predicate.render())
    }
    
    func addGroup<C>(_ group: Group<C>) {
        components.append(group.render())
    }
}
