import Foundation
@testable import Statement
@testable import StatementSQLite
import Testing

struct SQLiteDataTypeConvertibleTests {

    @Test func testBoolSqliteArgument() {
        var nonOptionalBool: Bool = true
        #expect(nonOptionalBool.sqliteArgument == "1")
        nonOptionalBool = false
        #expect(nonOptionalBool.sqliteArgument == "0")
        var optionalBool: Bool? = nil
        #expect(optionalBool.sqliteArgument == "NULL")
        optionalBool = true
        #expect(optionalBool.sqliteArgument == "1")
        optionalBool = false
        #expect(optionalBool.sqliteArgument == "0")
    }

    @Test func testDataSqliteArgument() throws {
        struct User: Encodable {
            let name: String
        }

        let data = try #require("A Bag Of Bytes".data(using: .utf8))
        let nonOptional: Data = data
        #expect(nonOptional.sqliteArgument == "'A Bag Of Bytes'")
        var optional: Data? = nil
        #expect(optional.sqliteArgument == "NULL")
        optional = try JSONEncoder().encode(User(name: "Merlin"))
        #expect(optional.sqliteArgument == "'{\"name\":\"Merlin\"}'")
    }

    @Test func testDateSqliteArgument() throws {
        let components = DateComponents(
            calendar: Calendar(identifier: .gregorian),
            timeZone: TimeZone(secondsFromGMT: 0),
            year: 2020,
            month: 1,
            day: 20,
            hour: 18,
            minute: 34,
            second: 02,
        )
        let date = try #require(components.date)

        let nonOptional: Date = date
        #expect(nonOptional.sqliteArgument == "1579545242.0")
        let optional: Date? = nil
        #expect(optional.sqliteArgument == "NULL")
    }

    @Test func testDoubleSqliteArgument() {
        let nonOptional: Double = 12.5
        #expect(nonOptional.sqliteArgument == "12.5")
        var optional: Double? = nil
        #expect(optional.sqliteArgument == "NULL")
        optional = 0.24
        #expect(optional.sqliteArgument == "0.24")
    }

    @Test func testIntSqliteArgument() {
        let nonOptional: Int = 42
        #expect(nonOptional.sqliteArgument == "42")
        var optional: Int? = nil
        #expect(optional.sqliteArgument == "NULL")
        optional = 1123
        #expect(optional.sqliteArgument == "1123")
    }

    @Test func testStringSqliteArgument() {
        let nonOptionalPlain: String = "A Non-Special String"
        #expect(nonOptionalPlain.sqliteArgument == "'A Non-Special String'")
        let nonOptionalSpecial: String = """
        A 'Special' String.
        Includes a line-break.
        """
        #expect(nonOptionalSpecial.sqliteArgument == "'A ''Special'' String.\nIncludes a line-break.'")
        var optional: String? = nil
        #expect(optional.sqliteArgument == "NULL")
        optional = "Hello World!"
        #expect(optional.sqliteArgument == "'Hello World!'")
    }

    @Test func testUUIDSqliteArgument() throws {
        let nonOptional: UUID = try #require(UUID(uuidString: "C9653570-3958-45C0-84C8-BC4A7449BE2C"))
        #expect(nonOptional.sqliteArgument == "'C9653570-3958-45C0-84C8-BC4A7449BE2C'")
        var optional: UUID? = nil
        #expect(optional.sqliteArgument == "NULL")
        optional = UUID(uuidString: "E1864730-2696-49FF-96F6-6450C3922FE8")
        #expect(optional.sqliteArgument == "'E1864730-2696-49FF-96F6-6450C3922FE8'")
    }
}
