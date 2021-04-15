import XCTest
import Statement
import StatementSQLite

final class SQLiteStatement_SelectContextTests: XCTestCase {
    
    static var allTests = [
        ("testSelect", testSelect),
    ]
    
    func testSelect() {
        let statement = SQLiteStatement(
            .SELECT(
                .column(Expression.id, tablePrefix: true),
                .column(Expression.name),
                .column(Expression.defaultLanguage),
                .column(Expression.comment),
                .column(Expression.feature)
            ),
            .FROM_TABLE(Expression.self),
            .JOIN_TABLE(Translation.self, on: Expression.id, equals: Translation.expressionID),
            .WHERE(
                .AND(
                    .column(Translation.language, op: .equal, value: "en"),
                    .column(Translation.region, op: .equal, value: "US")
                )
            ),
            .LIMIT(1)
        )
        
        XCTAssertEqual(statement.render(), """
        SELECT expression.id, name, default_language, comment, feature
        FROM expression
        JOIN translation ON expression.id = translation.expression_id
        WHERE translation.language_code = 'en' AND translation.region_code = 'US'
        LIMIT 1;
        """)
    }
}
