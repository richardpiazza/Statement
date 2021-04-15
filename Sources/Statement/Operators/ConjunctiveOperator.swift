public struct ConjunctiveOperator: ExpressibleByStringLiteral, Equatable {
    public let rawValue: String
    
    public init(stringLiteral value: String) {
        self.rawValue = value
    }
}

public extension ConjunctiveOperator {
    static let and: Self = "AND"
    static let or: Self = "OR"
}
