import Foundation

public protocol Renderer: AnyObject {
    var components: [String] { get set }
    func render() -> String
}

public extension Renderer {
    func addRaw(_ text: String) {
        components.append(text)
    }

    func addClause(_ clause: Clause<some Any>) {
        components.append(clause.render())
    }

    func addComparisonPredicate(_ predicate: ComparisonPredicate<some Any>) {
        components.append(predicate.render())
    }

    func addLogicalPredicate(_ predicate: LogicalPredicate<some Any>) {
        components.append(predicate.render())
    }

    func addConjunctivePredicate(_ predicate: ConjunctivePredicate<some Any>) {
        components.append(predicate.render())
    }

    func addGroup(_ group: Group<some Any>) {
        components.append(group.render())
    }
}
