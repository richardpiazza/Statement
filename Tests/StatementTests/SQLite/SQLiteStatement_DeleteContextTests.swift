import XCTest
import Statement
import StatementSQLite

final class SQLiteStatement_DeleteContextTests: XCTestCase {
    
    @available(*, deprecated)
    func testFrom() {
        let statement: SQLiteStatement = .init(
            .DELETE(
                .FROM(Expression.self)
            )
        )
        
        XCTAssertEqual(statement.render(), "DELETE FROM expression;")
    }
    
    func testDeleteFrom() {
        let statement: SQLiteStatement = .init(
            .DELETE(
                .FROM(CatalogExpression.self)
            )
        )
        
        XCTAssertEqual(statement.render(), "DELETE FROM expression;")
    }
    
    @available(*, deprecated)
    func testWhere() {
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
        WHERE id = 123;
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
    
    func testDeleteWhere() throws {
        let id = try XCTUnwrap(CatalogExpression["id"])
        
        var statement: SQLiteStatement = .init(
            .DELETE(
                .FROM(CatalogExpression.self)
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
                .FROM(CatalogExpression.self)
            ),
            .WHERE(
                .column(CatalogExpression.self, attribute: id, op: .equal, value: 123)
            )
        )
        
        XCTAssertEqual(statement.render(), """
        DELETE FROM expression
        WHERE expression.id = 123;
        """)
    }
}
