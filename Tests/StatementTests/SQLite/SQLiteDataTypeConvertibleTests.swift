import XCTest
@testable import Statement
@testable import StatementSQLite

final class SQLiteDataTypeConvertibleTests: XCTestCase {
    
    func testBoolSqliteArgument() throws {
        var nonOptionalBool: Bool = true
        XCTAssertEqual(nonOptionalBool.sqliteArgument, "1")
        nonOptionalBool = false
        XCTAssertEqual(nonOptionalBool.sqliteArgument, "0")
        var optionalBool: Bool? = nil
        XCTAssertEqual(optionalBool.sqliteArgument, "NULL")
        optionalBool = true
        XCTAssertEqual(optionalBool.sqliteArgument, "1")
        optionalBool = false
        XCTAssertEqual(optionalBool.sqliteArgument, "0")
    }
    
    func testDataSqliteArgument() throws {
        struct User: Encodable {
            let name: String
        }
        
        let data = try XCTUnwrap("A Bag Of Bytes".data(using: .utf8))
        let nonOptional: Data = data
        XCTAssertEqual(nonOptional.sqliteArgument, "A Bag Of Bytes")
        var optional: Data? = nil
        XCTAssertEqual(optional.sqliteArgument, "NULL")
        optional = try JSONEncoder().encode(User(name: "Merlin"))
        XCTAssertEqual(optional.sqliteArgument, "{\"name\":\"Merlin\"}")
    }
    
    func testDateSqliteArgument() throws {
        let components = DateComponents(
            calendar: Calendar(identifier: .gregorian),
            timeZone: TimeZone(secondsFromGMT: 0),
            year: 2020,
            month: 1,
            day: 20,
            hour: 18,
            minute: 34,
            second: 02
        )
        let date = try XCTUnwrap(components.date)
        
        let nonOptional: Date = date
        XCTAssertEqual(nonOptional.sqliteArgument, "1579545242")
        let optional: Date? = nil
        XCTAssertEqual(optional.sqliteArgument, "NULL")
    }
    
    func testDoubleSqliteArgument() throws {
        let nonOptional: Double = 12.5
        XCTAssertEqual(nonOptional.sqliteArgument, "12.5")
        var optional: Double? = nil
        XCTAssertEqual(optional.sqliteArgument, "NULL")
        optional = 0.24
        XCTAssertEqual(optional.sqliteArgument, "0.24")
    }
    
    func testIntSqliteArgument() throws {
        let nonOptional: Int = 42
        XCTAssertEqual(nonOptional.sqliteArgument, "42")
        var optional: Int? = nil
        XCTAssertEqual(optional.sqliteArgument, "NULL")
        optional = 1123
        XCTAssertEqual(optional.sqliteArgument, "1123")
    }
    
    func testStringSqliteArgument() throws {
        let nonOptionalPlain: String = "A Non-Special String"
        XCTAssertEqual(nonOptionalPlain.sqliteArgument, "'A Non-Special String'")
        let nonOptionalSpecial: String = """
        A 'Special' String.
        Includes a line-break.
        """
        XCTAssertEqual(nonOptionalSpecial.sqliteArgument, "'A ''Special'' String.\nIncludes a line-break.'")
        var optional: String? = nil
        XCTAssertEqual(optional.sqliteArgument, "NULL")
        optional = "Hello World!"
        XCTAssertEqual(optional.sqliteArgument, "'Hello World!'")
    }
    
    func testUUIDSqliteArgument() throws {
        let nonOptional: UUID = UUID(uuidString: "C9653570-3958-45C0-84C8-BC4A7449BE2C")!
        XCTAssertEqual(nonOptional.sqliteArgument, "'C9653570-3958-45C0-84C8-BC4A7449BE2C'")
        var optional: UUID? = nil
        XCTAssertEqual(optional.sqliteArgument, "NULL")
        optional = UUID(uuidString: "E1864730-2696-49FF-96F6-6450C3922FE8")
        XCTAssertEqual(optional.sqliteArgument, "'E1864730-2696-49FF-96F6-6450C3922FE8'")
    }
}
