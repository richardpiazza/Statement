import Statement

extension DataType {
    var sqliteDataType: String {
        switch self {
        case .string, .optional(.string), .url, .optional(.url):
            "TEXT"
        case .int, .optional(.int), .bool, .optional(.bool):
            "INTEGER"
        case .double, .optional(.double), .date, .optional(.date):
            "REAL"
        case .data, .optional(.data):
            "BLOB"
        default:
            "NULL"
        }
    }
}
