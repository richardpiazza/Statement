import Foundation

public struct ComparisonPredicate<Context> {
    public var op: ComparisonOperator
    public var elements: [any Renderable]

    public init(_ op: ComparisonOperator, elements: [any Renderable]) {
        self.op = op
        self.elements = elements
    }
}

public extension ComparisonPredicate {
    private class TempRenderer: Renderer {
        var components: [String] = []

        func render() -> String {
            components.joined(separator: " ")
        }
    }

    func render() -> String {
        let renderer = ComparisonRenderer(op)
        elements.forEach { $0.render(into: renderer) }
        return renderer.render()
    }
}

extension ComparisonPredicate: Renderable {
    public func render(into renderer: any Renderer) {
        renderer.addComparisonPredicate(self)
    }
}
