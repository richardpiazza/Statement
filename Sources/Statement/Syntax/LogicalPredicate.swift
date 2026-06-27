import Foundation

public struct LogicalPredicate<Context> {
    public var op: LogicalOperator
    public var elements: [any Renderable]

    public init(_ op: LogicalOperator, elements: [any Renderable]) {
        self.op = op
        self.elements = elements
    }
}

public extension LogicalPredicate {
    func render() -> String {
        let renderer = LogicalRenderer(op)
        elements.forEach { $0.render(into: renderer) }
        return renderer.render()
    }
}

extension LogicalPredicate: Renderable {
    public func render(into renderer: any Renderer) {
        renderer.addLogicalPredicate(self)
    }
}
