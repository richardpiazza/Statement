class ComparisonRenderer: Renderer {
    let op: ComparisonOperator
    let separator: String
    var components: [String] = []
    
    init(_ op: ComparisonOperator) {
        self.op = op
        self.separator = " \(op.rawValue) "
    }
    
    func render() -> String {
        guard components.count > 1 else {
            return ""
        }
        
        let lhs = components[0]
        let rhs = components[1]
        
        return lhs + " \(op.rawValue) " + rhs
    }
}
