import XCTest
import Statement
import StatementSQLite

final class EncodedValuesTests: XCTestCase {
    
    static var allTests = [
        ("testNull", testNull),
        ("testInteger", testInteger),
        ("testDouble", testDouble),
        ("testNonSpecialString", testNonSpecialString),
        ("testSpecialCharacterString", testSpecialCharacterString),
    ]
    
    func testNull() {
        let value = NSNull()
        XCTAssertEqual(value.sqlArgument(), "NULL")
    }
    
    func testInteger() {
        let value: Int = 16
        XCTAssertEqual(value.sqlArgument(), "16")
    }
    
    func testDouble() {
        let value: Double = 3.14159
        XCTAssertEqual(value.sqlArgument(), "3.14159")
    }
    
    func testNonSpecialString() {
        let value: String = "A non-special character string"
        XCTAssertEqual(value.sqlArgument(), "'A non-special character string'")
    }
    
    func testSpecialCharacterString() {
        let value: String = """
        A "Special" String
        With a line-break.
        """
        XCTAssertEqual(value.sqlArgument(), "'A \\\"Special\\\" String\\nWith a line-break.'")
    }
}
