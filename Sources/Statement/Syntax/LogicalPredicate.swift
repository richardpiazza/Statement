import Foundation

struct LogicalPredicate<Context> {
    var logicalOperator: LogicalOperator
    var elements: [AnyRenderable]
}

extension LogicalPredicate {
    func render() -> String {
        let renderer = LogicalRenderer(logicalOperator)
        elements.forEach { $0.render(into: renderer) }
        return renderer.render()
    }
}

extension LogicalPredicate: AnyRenderable {
    func render(into renderer: Renderer) {
        renderer.addRaw(render())
    }
}
