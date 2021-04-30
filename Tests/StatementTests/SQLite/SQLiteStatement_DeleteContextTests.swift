import XCTest
import Statement
import StatementSQLite

final class SQLiteStatement_DeleteContextTests: XCTestCase {
    
    static var allTests = [
        ("testDeleteFrom", testDeleteFrom),
    ]
    
    func testDeleteFrom() {
        let statement: SQLiteStatement = .init(
            .DELETE(
                .FROM(Expression.self)
            )
        )
        
        XCTAssertEqual(statement.render(), "DELETE FROM expression;")
    }
    
    func testDeleteWhere() {
        var statement: SQLiteStatement = .init(
            .DELETE(
                .FROM(Expression.self)
            ),
            .WHERE(
                .column(Expression.id, op: .equal, value: 123)
            )
        )
        
        XCTAssertEqual(statement.render(), """
        DELETE FROM expression
        WHERE expression.id = 123;
        """)
        
        statement = .init(
            .DELETE(
                .FROM(Expression.self)
            ),
            .WHERE(
                .column(Expression.id, tablePrefix: false, op: .equal, value: 123)
            )
        )
        
        XCTAssertEqual(statement.render(), """
        DELETE FROM expression
        WHERE id = 123;
        """)
    }
}
