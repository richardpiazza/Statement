import Foundation

class LogicalRenderer: Renderer {
    let `operator`: LogicalOperator
    let separator: String
    var components: [String] = []
    
    init(_ op: LogicalOperator) {
        self.operator = op
        self.separator = " \(op.operator) "
    }
    
    func render() -> String {
        components.joined(separator: separator)
    }
}
