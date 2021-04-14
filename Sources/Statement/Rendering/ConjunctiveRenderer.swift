class ConjunctiveRenderer: Renderer {
    let op: ConjunctiveOperator
    let separator: String
    var components: [String] = []
    
    init(_ op: ConjunctiveOperator) {
        self.op = op
        self.separator = " \(op.sqlArgument()) "
    }
    
    func render() -> String {
        if components.count == 1 {
            return components[0]
        } else {
            return components.joined(separator: separator)
        }
    }
}
