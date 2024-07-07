public struct ConjunctivePredicate<Context> {
    public var op: ConjunctiveOperator
    public var elements: [Renderable]
    
    public init(_ op: ConjunctiveOperator, elements: [Renderable]) {
        self.op = op
        self.elements = elements
    }
}

public extension ConjunctivePredicate {
    func render() -> String {
        let renderer = ConjunctiveRenderer(op)
        elements.forEach { $0.render(into: renderer) }
        return renderer.render()
    }
}

extension ConjunctivePredicate: Renderable {
    public func render(into renderer: Renderer) {
        renderer.addConjunctivePredicate(self)
    }
}
