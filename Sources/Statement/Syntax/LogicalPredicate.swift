import Foundation

public struct LogicalPredicate<Context> {
    public var op: LogicalOperator
    public var elements: [AnyRenderable]
    
    public init(_ op: LogicalOperator, elements: [AnyRenderable]) {
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

extension LogicalPredicate: AnyRenderable {
    public func render(into renderer: Renderer) {
        renderer.addLogicalPredicate(self)
    }
}
