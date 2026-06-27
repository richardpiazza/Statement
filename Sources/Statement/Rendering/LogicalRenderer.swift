import Foundation

class LogicalRenderer: Renderer {
    let op: LogicalOperator
    let separator: String
    var components: [String] = []

    init(_ op: LogicalOperator) {
        self.op = op
        separator = " \(op.rawValue) "
    }

    func render() -> String {
        if components.count == 1 {
            components.joined() + " " + op.rawValue
        } else {
            components.joined(separator: separator)
        }
    }
}
