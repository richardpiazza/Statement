import Foundation

struct LogicalPredicate<Context> {
    var logicalOperator: LogicalOperator
    var elements: [AnyElement]
}

extension LogicalPredicate {
    func render() -> String {
        let renderer = LogicalRenderer(logicalOperator)
        elements.forEach { $0.render(into: renderer)}
        return renderer.render()
    }
}

extension LogicalPredicate: AnyElement {
    func render(into renderer: Renderer) {
        renderer.addRaw(render())
    }
}
