import XCTest
import Statement
import StatementSQLite

final class SQLiteStatement_SelectContextTests: XCTestCase {
    
    func testSelectFromTable() throws {
        let entity = Expression()
        let id = try XCTUnwrap(entity["id"])
        let name = try XCTUnwrap(entity["name"])
        let defaultLanguage = try XCTUnwrap(entity["default_language"])
        let comment = try XCTUnwrap(entity["comment"])
        let feature = try XCTUnwrap(entity["feature"])
        
        let statement: SQLiteStatement = .init(
            .SELECT(
                .column(id),
                .column(name),
                .column(defaultLanguage),
                .column(comment),
                .column(feature)
            ),
            .FROM_TABLE(Expression.self)
        )
        
        XCTAssertEqual(statement.render(), """
        SELECT id, name, default_language, comment, feature
        FROM expression;
        """)
    }
    
    func testSelectFromWhere() throws {
        let entity = Expression()
        let id = try XCTUnwrap(entity["id"])
        let name = try XCTUnwrap(entity["name"])
        let defaultLanguage = try XCTUnwrap(entity["default_language"])
        let comment = try XCTUnwrap(entity["comment"])
        let feature = try XCTUnwrap(entity["feature"])
        
        let statement: SQLiteStatement = .init(
            .SELECT(
                .column(Expression.self, attribute: id),
                .column(name),
                .column(defaultLanguage),
                .column(comment),
                .column(feature)
            ),
            .FROM(
                .TABLE(Expression.self)
            ),
            .WHERE(
                .column(name, op: .equal, value: "Setup")
            )
        )
        
        XCTAssertEqual(statement.render(), """
        SELECT expression.id, name, default_language, comment, feature
        FROM expression
        WHERE name = 'Setup';
        """)
    }
    
    func testSelectFromWhereLimit() throws {
        let expressionEntity = Expression()
        let id = try XCTUnwrap(expressionEntity["id"])
        let name = try XCTUnwrap(expressionEntity["name"])
        let defaultLanguage = try XCTUnwrap(expressionEntity["default_language"])
        let comment = try XCTUnwrap(expressionEntity["comment"])
        let feature = try XCTUnwrap(expressionEntity["feature"])
        
        let translationEntity = Translation()
        let expressionId = try XCTUnwrap(translationEntity["expression_id"])
        let language = try XCTUnwrap(translationEntity["language_code"])
        let region = try XCTUnwrap(translationEntity["region_code"])
        
        let statement: SQLiteStatement = .init(
            .SELECT(
                .attribute(Expression.self, attribute: id),
                .attribute(name),
                .attribute(defaultLanguage),
                .attribute(comment),
                .attribute(feature)
            ),
            .FROM(
                .TABLE(Expression.self),
                .JOIN_ON(Translation.self, attribute: expressionId, equals: Expression.self, attribute: id)
            ),
            .WHERE(
                .AND(
                    .column(language, entity: Translation(), op: .equal, value: "en"),
                    .column(region, entity: Translation(), op: .equal, value: "US")
                )
            ),
            .LIMIT(1)
        )
        
        XCTAssertEqual(statement.render(), """
        SELECT expression.id, name, default_language, comment, feature
        FROM expression JOIN translation ON translation.expression_id = expression.id
        WHERE translation.language_code = 'en' AND translation.region_code = 'US'
        LIMIT 1;
        """)
    }
}
