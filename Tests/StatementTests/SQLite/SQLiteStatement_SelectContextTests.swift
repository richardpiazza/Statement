import XCTest
import Statement
import StatementSQLite

final class SQLiteStatement_SelectContextTests: XCTestCase {
    
    static var allTests = [
        ("testSelect", testSelect),
    ]
    
    func testSelect() {
        var statement: SQLiteStatement = .init(
            .SELECT(
                .column(Expression.id),
                .column(Expression.name),
                .column(Expression.defaultLanguage),
                .column(Expression.comment),
                .column(Expression.feature)
            ),
            .FROM_TABLE(Expression.self)
        )
        
        XCTAssertEqual(statement.render(), """
        SELECT id, name, default_language, comment, feature
        FROM expression;
        """)
        
        statement = .init(
            .SELECT(
                .column(Expression.id, tablePrefix: true),
                .column(Expression.name),
                .column(Expression.defaultLanguage),
                .column(Expression.comment),
                .column(Expression.feature)
            ),
            .FROM(
                .TABLE(Expression.self)
            ),
            .WHERE(
                .column(Expression.name, op: .equal, value: "Setup")
            )
        )
        
        XCTAssertEqual(statement.render(), """
        SELECT expression.id, name, default_language, comment, feature
        FROM expression
        WHERE name = 'Setup';
        """)
        
        statement = .init(
            .SELECT(
                .column(Expression.id, tablePrefix: true),
                .column(Expression.name),
                .column(Expression.defaultLanguage),
                .column(Expression.comment),
                .column(Expression.feature)
            ),
            .FROM(
                .TABLE(Expression.self),
                .JOIN(Translation.self, on: Expression.id, equals: Translation.expressionID)
            ),
            .WHERE(
                .AND(
                    .column(Translation.language, tablePrefix: true, op: .equal, value: "en"),
                    .column(Translation.region, tablePrefix: true, op: .equal, value: "US")
                )
            ),
            .LIMIT(1)
        )
        
        XCTAssertEqual(statement.render(), """
        SELECT expression.id, name, default_language, comment, feature
        FROM expression JOIN translation ON expression.id = translation.expression_id
        WHERE translation.language_code = 'en' AND translation.region_code = 'US'
        LIMIT 1;
        """)
    }
}
