import Foundation

public struct LogicalPredicate<Context> {
    public var op: LogicalOperator
    public var elements: [Renderable]
    
    public init(_ op: LogicalOperator, elements: [Renderable]) {
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
    public func render(into renderer: Renderer) {
        renderer.addLogicalPredicate(self)
    }
}
