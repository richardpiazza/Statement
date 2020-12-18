import Foundation

protocol Renderer {
    func addRaw(_ text: String)
    func addClause<C>(_ clause: Clause<C>)
    func addPredicate<C>(_ predicate: Predicate<C>)
    func addLogicalPredicate<C>(_ logicalPredicate: LogicalPredicate<C>)
    func addGroup<C>(_ group: Group<C>)
}
