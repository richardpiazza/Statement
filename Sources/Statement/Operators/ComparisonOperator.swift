import Foundation

enum ComparisonOperator {
    case equal(Encodable)
    case notEqual(Encodable)
    case greaterThan(Encodable)
    case greaterThanEqualTo(Encodable)
    case lessThan(Encodable)
    case lessThanEqualTo(Encodable)
    
    var op: String {
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
        var components: [String] = [op]
        
        switch self {
        case .equal(let encodable),
             .notEqual(let encodable),
             .greaterThan(let encodable),
             .greaterThanEqualTo(let encodable),
             .lessThan(let encodable),
             .lessThanEqualTo(let encodable):
            
            components.append(encodable.sqlString)
        }
        
        return components.joined(separator: " ")
    }
}
