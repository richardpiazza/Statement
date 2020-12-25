import Foundation

private var encoder: JSONEncoder = {
    let encoder = JSONEncoder()
    return encoder
}()

public extension Encodable {
    /// A string representation the instance suitable for using as an argument in SQL statements.
    ///
    /// Rules apply to various types:
    /// * A `NSNull` will output _NULL_.
    /// * Integers and Doubles will be outputted as is.
    /// * Strings will be bracketed by the prefix/suffix characters.
    ///
    /// - parameter stringPrefixCharacter:
    /// - parameter stringSuffixCharacter:
    func sqlArgument(stringPrefixCharacter: Character = "'", stringSuffixCharacter: Character = "'") -> String {
        switch self {
        case is NSNull: return "NULL"
        case let value as Int: return "\(value)"
        case let value as Double: return "\(value)"
        default:
            break
        }
        
        guard let data = try? encoder.encode(self) else {
            return ""
        }
        
        guard let value = String(data: data, encoding: .utf8) else {
            return ""
        }
        
        switch self {
        case is String:
            let output = value.dropFirst().dropLast()
            return "\(stringPrefixCharacter)\(output)\(stringSuffixCharacter)"
        default:
            return value
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
