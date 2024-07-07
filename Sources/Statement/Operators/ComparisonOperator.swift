public struct ComparisonOperator: ExpressibleByStringLiteral, Equatable, Sendable {
    public let rawValue: String
    
    public init(stringLiteral value: String) {
        self.rawValue = value
    }
}

public extension ComparisonOperator {
    static let equal: Self = "="
    static let notEqual: Self = "<>"
    static let greaterThan: Self = ">"
    static let greaterThanEqualTo: Self = ">="
    static let lessThan: Self = "<"
    static let lessThanEqualTo: Self = "<="
}
