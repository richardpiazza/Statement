import Foundation

public struct Keyword: ExpressibleByStringLiteral, Codable {
    public var value: String
    
    public init(stringLiteral value: String) {
        self.value = value
    }
    
    /// Creates a multi-word keyword (separated by spaces).
    public static func compound(_ keywords: Keyword...) -> Keyword {
        Keyword(stringLiteral: keywords.map { $0.value }.joined(separator: " "))
    }
}

public extension Keyword {
    static let add: Self = "ADD"
    static let alter: Self = "ALTER"
    static let and: Self = "AND"
    static let autoIncrement: Self = "AUTOINCREMENT"
    static let column: Self = "COLUMN"
    static let create: Self = "CREATE"
    static let `default`: Self = "DEFAULT"
    static let delete: Self = "DELETE"
    static let drop: Self = "DROP"
    static let foreign: Self = "FOREIGN"
    static let from: Self = "FROM"
    static let having: Self = "HAVING"
    static let insert: Self = "INSERT"
    static let into: Self = "INTO"
    static let join: Self = "JOIN"
    static let key: Self = "KEY"
    static let limit: Self = "LIMIT"
    static let not: Self = "NOT"
    static let null: Self = "NULL"
    static let on: Self = "ON"
    static let or: Self = "OR"
    static let primary: Self = "PRIMARY"
    static let references: Self = "REFERENCES"
    static let rename: Self = "RENAME"
    static let select: Self = "SELECT"
    static let set: Self = "SET"
    static let table: Self = "TABLE"
    static let to: Self = "TO"
    static let unique: Self = "UNIQUE"
    static let update: Self = "UPDATE"
    static let values: Self = "VALUES"
    static let `where`: Self = "WHERE"
}
