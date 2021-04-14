import Foundation

class LogicalRenderer: Renderer {
    let op: LogicalOperator
    let separator: String
    var components: [String] = []
    
    init(_ op: LogicalOperator) {
        self.op = op
        self.separator = " \(op.rawValue) "
    }
    
    func render() -> String {
        if components.count == 1 {
            return components.joined() + " " + op.rawValue
        } else {
            return components.joined(separator: separator)
        }
    }
}
