import XCTest
@testable import Statement
@testable import StatementSQLite

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
    
    func testSelect2Statement() {
        let statement = Statement {
            Select {
                Column("whatever")
            }
        }
        let sql = statement.render()
        var entity = Expression()
        entity[keyPath: \.name] = ""
        XCTAssertEqual(sql, "SELECT whatever")
    }
}
