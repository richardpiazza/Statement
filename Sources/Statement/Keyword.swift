import Foundation

struct Keyword<Context>: Codable, RawRepresentable {
    var rawValue: String
}

extension Keyword where Context == SQLiteStatement.StatementContext {
    static let SELECT: Keyword = Keyword(rawValue: "SELECT")
    static let FROM: Keyword = Keyword(rawValue: "FROM")
    static let JOIN: Keyword = Keyword(rawValue: "JOIN")
    static let WHERE: Keyword = Keyword(rawValue: "WHERE")
}

extension Keyword where Context == SQLiteStatement.JoinContext {
    static let ON: Keyword = Keyword(rawValue: "ON")
}
