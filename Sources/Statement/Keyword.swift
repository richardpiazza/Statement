import Foundation

struct Keyword: ExpressibleByStringLiteral, Codable {
    var value: String
    
    init(stringLiteral value: String) {
        self.value = value
    }
}

extension Keyword {
    static let and: Self = "AND"
    static let autoIncrement: Self = "AUTOINCREMENT"
    static let create: Self = "CREATE"
    static let foreign: Self = "FOREIGN"
    static let from: Self = "FROM"
    static let insert: Self = "INSERT"
    static let into: Self = "INTO"
    static let join: Self = "JOIN"
    static let key: Self = "KEY"
    static let limit: Self = "LIMIT"
    static let on: Self = "ON"
    static let or: Self = "OR"
    static let primary: Self = "PRIMARY"
    static let references: Self = "REFERENCES"
    static let select: Self = "SELECT"
    static let set: Self = "SET"
    static let table: Self = "TABLE"
    static let unique: Self = "UNIQUE"
    static let update: Self = "UPDATE"
    static let values: Self = "VALUES"
    static let `where`: Self = "WHERE"
}
