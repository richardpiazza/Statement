import Foundation

enum ComparisonOperator {
    case equal(Encodable)
    case notEqual(Encodable)
    case greaterThan(Encodable)
    case greaterThanEqualTo(Encodable)
    case lessThan(Encodable)
    case lessThanEqualTo(Encodable)
    
    var `operator`: String {
        switch self {
        case .equal: return "="
        case .notEqual: return "<>"
        case .greaterThan: return ">"
        case .greaterThanEqualTo: return ">="
        case .lessThan: return "<"
        case .lessThanEqualTo: return "<="
        }
    }
    
    var expression: String {
        var expression: String = ""
        expression += `operator`
        
        switch self {
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
        
        return expression
    }
}
