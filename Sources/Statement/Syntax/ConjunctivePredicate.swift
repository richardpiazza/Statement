public struct ConjunctivePredicate<Context> {
    public var op: ConjunctiveOperator
    public var elements: [any Renderable]

    public init(_ op: ConjunctiveOperator, elements: [any Renderable]) {
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
    public func render(into renderer: any Renderer) {
        renderer.addConjunctivePredicate(self)
    }
}
