import Foundation
import Statement

extension DataTypeConvertible {
    /// A string representation the instance, suitable for using as an argument in SQL statements.
    ///
    /// Rules apply to various types:
    /// * Any nil `Optional` will output _NULL_.
    /// * Integers and Doubles will be outputted as is.
    /// * Strings will be bracketed by single quotes (_'_).
    var sqliteArgument: String {
        switch self {
        case let value as Bool:
            value ? "1" : "0"
        case let value as Data:
            .singleQuote + (String(data: value, encoding: .utf8) ?? "") + .singleQuote
        case let value as Date:
            "\(value.timeIntervalSince1970)"
        case let value as Double:
            "\(value)"
        case let value as Int:
            "\(value)"
        case let value as String:
            .singleQuote + value.replacingOccurrences(of: String.singleQuote, with: String.doubleQuote) + .singleQuote
        case let value as URL:
            .singleQuote + value.absoluteString.replacingOccurrences(of: String.singleQuote, with: String.doubleQuote) + .singleQuote
        case let value as UUID:
            .singleQuote + value.uuidString + .singleQuote
        case let value as Optional<Bool>:
            value?.sqliteArgument ?? Keyword.null.rawValue
        case let value as Optional<Data>:
            value?.sqliteArgument ?? Keyword.null.rawValue
        case let value as Optional<Date>:
            value?.sqliteArgument ?? Keyword.null.rawValue
        case let value as Optional<Double>:
            value?.sqliteArgument ?? Keyword.null.rawValue
        case let value as Optional<Int>:
            value?.sqliteArgument ?? Keyword.null.rawValue
        case let value as Optional<String>:
            value?.sqliteArgument ?? Keyword.null.rawValue
        case let value as Optional<UUID>:
            value?.sqliteArgument ?? Keyword.null.rawValue
        default:
            String(describing: self)
        }
    }
}

extension DataTypeConvertible? {
    var sqliteArgument: String {
        switch self {
        case let value as Optional<Bool>:
            value?.sqliteArgument ?? Keyword.null.rawValue
        case let value as Optional<Data>:
            value?.sqliteArgument ?? Keyword.null.rawValue
        case let value as Optional<Date>:
            value?.sqliteArgument ?? Keyword.null.rawValue
        case let value as Optional<Double>:
            value?.sqliteArgument ?? Keyword.null.rawValue
        case let value as Optional<Int>:
            value?.sqliteArgument ?? Keyword.null.rawValue
        case let value as Optional<String>:
            value?.sqliteArgument ?? Keyword.null.rawValue
        case let value as Optional<URL>:
            value?.sqliteArgument ?? Keyword.null.rawValue
        case let value as Optional<UUID>:
            value?.sqliteArgument ?? Keyword.null.rawValue
        default:
            String(describing: self)
        }
    }
}

extension String {
    static var singleQuote: String { "'" }
    static var doubleQuote: String { "''" }
}
