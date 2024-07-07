import Foundation

public struct ComparisonPredicate<Context> {
    public var op: ComparisonOperator
    public var elements: [Renderable]
    
    public init(_ op: ComparisonOperator, elements: [Renderable]) {
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
    public func render(into renderer: Renderer) {
        renderer.addComparisonPredicate(self)
    }
}
