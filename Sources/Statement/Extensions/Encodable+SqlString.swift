import Foundation

public extension Encodable {
    var sqlString: String {
        switch self {
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
