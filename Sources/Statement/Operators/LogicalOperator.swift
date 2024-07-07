public struct LogicalOperator: ExpressibleByStringLiteral, Equatable, Sendable {
    public let rawValue: String
    
    public init(stringLiteral value: String) {
        self.rawValue = value
    }
}

public extension LogicalOperator {
    static let all: Self = "ALL"
    static let and: Self = "AND"
    static let any: Self = "ANY"
    static let asc: Self = "ASC"
    static let between: Self = "BETWEEN"
    static let desc: Self = "DESC"
    static let exists: Self = "EXISTS"
    static let `in`: Self = "IN"
    static let isNotNull: Self = "IS NOT NULL"
    static let isNull: Self = "IS NULL"
    static let like: Self = "LIKE"
    static let not: Self = "NOT"
    static let or: Self = "OR"
    static let some: Self = "SOME"
}
