import Foundation

public enum LogicalOperator {
    case all
    case and
    case any
    case between
    case exists
    case `in`
    case isNotNull
    case isNull
    case like
    case not
    case or
    case some
    
    
    public var `operator`: String {
        switch self {
        case .all: return "ALL"
        case .and: return "AND"
        case .any: return "ANY"
        case .between: return "BETWEEN"
        case .exists: return "EXISTS"
        case .`in`: return "IN"
        case .isNotNull: return "IS NOT NULL"
        case .isNull: return "IS NULL"
        case .like: return "LIKE"
        case .not: return "NOT"
        case .or: return "OR"
        case .some: return "SOME"
        }
    }
}
