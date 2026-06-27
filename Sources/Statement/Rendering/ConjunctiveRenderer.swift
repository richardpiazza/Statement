class ConjunctiveRenderer: Renderer {
    let op: ConjunctiveOperator
    let separator: String
    var components: [String] = []

    init(_ op: ConjunctiveOperator) {
        self.op = op
        separator = " \(op.rawValue) "
    }

    func render() -> String {
        if components.count == 1 {
            components[0]
        } else {
            components.joined(separator: separator)
        }
    }
}
