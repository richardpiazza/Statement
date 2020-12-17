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
    static let join: Self = "JOIN"
    static let or: Self = "OR"
    static let select: Self = "SELECT"
    static let set: Self = "SET"
    static let update: Self = "UPDATE"
    static let `where`: Self = "WHERE"
}
