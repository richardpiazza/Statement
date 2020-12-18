import Foundation

struct Keyword: ExpressibleByStringLiteral, Codable {
    var value: String
    
    init(stringLiteral value: String) {
        self.value = value
    }
}

extension Keyword {
    static let and: Self = "AND"
    static let from: Self = "FROM"
    static let insert: Self = "INSERT"
    static let into: Self = "INTO"
    static let join: Self = "JOIN"
    static let limit: Self = "LIMIT"
    static let on: Self = "ON"
    static let or: Self = "OR"
    static let select: Self = "SELECT"
    static let set: Self = "SET"
    static let update: Self = "UPDATE"
    static let values: Self = "VALUES"
    static let `where`: Self = "WHERE"
}
