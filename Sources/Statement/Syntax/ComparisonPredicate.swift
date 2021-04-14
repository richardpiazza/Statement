import Foundation

public struct ComparisonPredicate<Context> {
    public var op: ComparisonOperator
    public var elements: [AnyRenderable]
    
    public init(_ op: ComparisonOperator, elements: [AnyRenderable]) {
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
        guard elements.count > 1 else {
            return ""
        }
        
        let renderer = TempRenderer()
        elements[0].render(into: renderer)
        elements[1].render(into: renderer)
        
        let lhs = renderer.components[0]
        let rhs = renderer.components[1]
        
        return lhs + " \(op.op) " + rhs
    }
}

extension ComparisonPredicate: AnyRenderable {
    public func render(into renderer: Renderer) {
        renderer.addComparisonPredicate(self)
    }
}
