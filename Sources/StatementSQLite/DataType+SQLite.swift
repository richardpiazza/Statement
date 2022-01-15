import Statement

public extension DataType {
    var sqliteDataType: String {
        switch self {
        case .string, .optional(.string), .url, .optional(.url):
            return "TEXT"
        case .int, .optional(.int), .bool, .optional(.bool), .date, .optional(.date):
            return "INTEGER"
        case .double, .optional(.double):
            return "REAL"
        case .data, .optional(.data):
            return "BLOB"
        default:
            return "NULL"
        }
    }
}
