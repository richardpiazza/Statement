import XCTest
import Statement
import StatementSQLite

final class SQLiteStatement_OrderContextTests: XCTestCase {
    
    func testSelectOrderBy() throws {
        let entity = Expression()
        let name = try XCTUnwrap(entity["name"])
        
        let statement = SQLiteStatement(
            .SELECT(
                .column(name)
            ),
            .FROM_TABLE(Expression.self),
            .ORDER_BY(
                .column(name, op: .desc)
            )
        )
        
        XCTAssertEqual(statement.render(), """
        SELECT name
        FROM expression
        ORDER BY name DESC;
        """)
    }
}
