import XCTest
import Statement
import StatementSQLite

final class SQLiteStatement_DeleteContextTests: XCTestCase {
    
    func testDeleteFrom() {
        let statement: SQLiteStatement = .init(
            .DELETE(
                .FROM(Expression.self)
            )
        )
        
        XCTAssertEqual(statement.render(), "DELETE FROM expression;")
    }
    
    func testDeleteWhere() throws {
        let entity = Expression()
        let id = try XCTUnwrap(entity["id"])
        
        var statement: SQLiteStatement = .init(
            .DELETE(
                .FROM(Expression.self)
            ),
            .WHERE(
                .column(id, op: .equal, value: 123)
            )
        )
        
        XCTAssertEqual(statement.render(), """
        DELETE FROM expression
        WHERE id = 123;
        """)
        
        statement = .init(
            .DELETE(
                .FROM(Expression.self)
            ),
            .WHERE(
                .column(Expression.self, attribute: id, op: .equal, value: 123)
            )
        )
        
        XCTAssertEqual(statement.render(), """
        DELETE FROM expression
        WHERE expression.id = 123;
        """)
    }
}
