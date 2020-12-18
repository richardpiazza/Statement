import Foundation

class LogicalRenderer: Renderer {
    let `operator`: LogicalOperator
    private var expressions: [String] = []
    
    init(_ `operator`: LogicalOperator) {
        self.operator = `operator`
    }
    
    func render() -> String {
        expressions.joined(separator: " \(`operator`.operator) ")
    }
}

extension LogicalRenderer {
    func addRaw(_ text: String) {
        expressions.append(text)
    }
    
    func addElement(_ element: Element) {
        switch element {
        case .expression(let column, let predicate):
            var expression: String = ""
            expression += "\(type(of: column).tableName).\(column.stringValue)"
            expression += " \(predicate.operator) "
            
            switch predicate {
            case .equal(let encodable):
                switch encodable {
                case let value as String:
                    expression += "\"\(value)\""
                case let value as Int:
                    expression += "\(value)"
                case let value as Double:
                    expression += "\(value)"
                default:
                    //TODO
                    break
                }
            default:
                //TODO
                break
            }
            
            expressions.append(expression)
        default:
            // TODO
            break
        }
    }
}
