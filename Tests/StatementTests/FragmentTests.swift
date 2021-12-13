import XCTest
@testable import Statement

final class FragmentTests: XCTestCase {
    
    func testRenderEmptyStatement() {
        let statement = Statement {
        }
        let sql = statement.render()
        XCTAssertEqual(sql, "")
    }
    
    func testSelectStatement() {
        let statement = Statement {
            Select {
                Fragment(value: .raw("all"))
            }
        }
        let sql = statement.render()
        XCTAssertEqual(sql, "SELECT all")
    }
}
