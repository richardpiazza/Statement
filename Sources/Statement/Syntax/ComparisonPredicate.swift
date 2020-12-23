import Foundation

public struct ComparisonPredicate<Context> {
    public var column: AnyColumn
    public var comparison: ComparisonOperator
}

public extension ComparisonPredicate {
    func render() -> String {
        column.identifier + " " + comparison.expression
    }
}

extension ComparisonPredicate: AnyRenderable {
    public func render(into renderer: Renderer) {
        renderer.addComparisonPredicate(self)
    }
}
