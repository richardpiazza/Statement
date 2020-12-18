import Foundation

@available(*, deprecated, message: "Use `LogicalOperator` and `ComparisonOperator`.")
enum OldPredicate {
    case equal(Encodable)
    case notEqual(Encodable)
    case greaterThan(Encodable)
    case greaterThanEqualTo(Encodable)
    case lessThan(Encodable)
    case lessThanEqualTo(Encodable)
    case `in`([Encodable])
    case between(Encodable, Encodable)
    case like(Encodable)
    case isNull
    case isNotNull
    
    var `operator`: String {
        switch self {
        case .equal: return "="
        case .notEqual: return "<>"
        case .greaterThan: return ">"
        case .greaterThanEqualTo: return ">="
        case .lessThan: return "<"
        case .lessThanEqualTo: return "<="
        case .`in`: return "IN"
        case .between: return "BETWEEN"
        case .like: return "LIKE"
        case .isNull: return "IS NULL"
        case .isNotNull: return "IS NOT NULL"
        }
    }
}
