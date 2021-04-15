import Foundation

public extension Encodable {
    private var singleQuote: String { "'" }
    private var doubleQuote: String { "''" }
    
    /// A string representation the instance suitable for using as an argument in SQL statements.
    ///
    /// Rules apply to various types:
    /// * A `NSNull` will output _NULL_.
    /// * Integers and Doubles will be outputted as is.
    /// * Strings will be bracketed by the single _'_ quotes.
    func sqlArgument() -> String {
        switch self {
        case is NSNull: return Keyword.null.rawValue
        case let value as Int: return "\(value)"
        case let value as Double: return "\(value)"
        case let value as String:
            let newValue = value
                .replacingOccurrences(of: singleQuote, with: doubleQuote)
            return "\(singleQuote)\(newValue)\(singleQuote)"
        default:
            return String(describing: self)
        }
    }
    
    @available(*, deprecated, renamed: "sqlArgument()")
    var sqlString: String {
        return sqlArgument()
    }
}

extension NSNull: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
