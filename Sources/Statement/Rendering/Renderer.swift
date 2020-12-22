import Foundation

public protocol Renderer {
    func addRaw(_ text: String)
    func addClause<C>(_ clause: Clause<C>)
    func addComparisonPredicate<C>(_ predicate: ComparisonPredicate<C>)
    func addLogicalPredicate<C>(_ logicalPredicate: LogicalPredicate<C>)
    func addGroup<C>(_ group: Group<C>)
}
