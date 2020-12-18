import Foundation

enum Segment<Context> {
    case clause(Clause<Context>)
    case predicate(Predicate<Context>)
    case logicalPredicate(LogicalPredicate<Context>)
}

extension Segment: AnyElement {
    func render(into renderer: Renderer) {
        switch self {
        case .clause(let clause):
            renderer.addRaw(clause.render())
        case .predicate(let predicate):
            predicate.render(into: renderer)
        case .logicalPredicate(let predicate):
            renderer.addRaw(predicate.render())
        }
    }
}
