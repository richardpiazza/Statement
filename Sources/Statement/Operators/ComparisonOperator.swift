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
            
            components.append(stringFrom(encodable))
        }
        
        return components.joined(separator: " ")
    }
    
    private func stringFrom(_ encodable: Encodable) -> String {
        switch encodable {
        case let value as String: return "\"\(value)\""
        case let value as Int: return "\(value)"
        case let value as Double: return "\(value)"
        case is NSNull: return "NULL"
        default:
            //TODO
            return ""
        }
    }
}

extension NSNull: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
