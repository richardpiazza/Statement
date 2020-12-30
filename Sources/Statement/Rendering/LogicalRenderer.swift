import Foundation

class LogicalRenderer: Renderer {
    let op: LogicalOperator
    let separator: String
    var components: [String] = []
    
    init(_ op: LogicalOperator) {
        self.op = op
        self.separator = " \(op.operator) "
    }
    
    func render() -> String {
        if components.count == 1 {
            return components.joined() + " " + op.operator
        } else {
            return components.joined(separator: separator)
        }
    }
}
