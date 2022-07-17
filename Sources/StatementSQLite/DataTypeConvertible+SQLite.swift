import Statement
import Foundation

public extension DataTypeConvertible {
    /// A string representation the instance, suitable for using as an argument in SQL statements.
    ///
    /// Rules apply to various types:
    /// * Any nil `Optional` will output _NULL_.
    /// * Integers and Doubles will be outputted as is.
    /// * Strings will be bracketed by single quotes (_'_).
    var sqliteArgument: String {
        switch self {
        case let value as Bool:
            return value ? "1" : "0"
        case let value as Data:
            return .singleQuote + (String(data: value, encoding: .utf8) ?? "") + .singleQuote
        case let value as Date:
            return "\(value.timeIntervalSince1970)"
        case let value as Double:
            return "\(value)"
        case let value as Int:
            return "\(value)"
        case let value as String:
            return .singleQuote + value.replacingOccurrences(of: String.singleQuote, with: String.doubleQuote) + .singleQuote
        case let value as URL:
            return .singleQuote + value.absoluteString.replacingOccurrences(of: String.singleQuote, with: String.doubleQuote) + .singleQuote
        case let value as UUID:
            return .singleQuote + value.uuidString + .singleQuote
        case let value as Optional<Bool>:
            return value?.sqliteArgument ?? Keyword.null.rawValue
        case let value as Optional<Data>:
            return value?.sqliteArgument ?? Keyword.null.rawValue
        case let value as Optional<Date>:
            return value?.sqliteArgument ?? Keyword.null.rawValue
        case let value as Optional<Double>:
            return value?.sqliteArgument ?? Keyword.null.rawValue
        case let value as Optional<Int>:
            return value?.sqliteArgument ?? Keyword.null.rawValue
        case let value as Optional<String>:
            return value?.sqliteArgument ?? Keyword.null.rawValue
        case let value as Optional<UUID>:
            return value?.sqliteArgument ?? Keyword.null.rawValue
        default:
            return String(describing: self)
        }
    }
}

public extension Optional where Wrapped == DataTypeConvertible {
    var sqliteArgument: String {
        switch self {
        case let value as Optional<Bool>:
            return value?.sqliteArgument ?? Keyword.null.rawValue
        case let value as Optional<Data>:
            return value?.sqliteArgument ?? Keyword.null.rawValue
        case let value as Optional<Date>:
            return value?.sqliteArgument ?? Keyword.null.rawValue
        case let value as Optional<Double>:
            return value?.sqliteArgument ?? Keyword.null.rawValue
        case let value as Optional<Int>:
            return value?.sqliteArgument ?? Keyword.null.rawValue
        case let value as Optional<String>:
            return value?.sqliteArgument ?? Keyword.null.rawValue
        case let value as Optional<URL>:
            return value?.sqliteArgument ?? Keyword.null.rawValue
        case let value as Optional<UUID>:
            return value?.sqliteArgument ?? Keyword.null.rawValue
        default:
            return String(describing: self)
        }
    }
}

private extension String {
    static var singleQuote: String { "'" }
    static var doubleQuote: String { "''" }
}
