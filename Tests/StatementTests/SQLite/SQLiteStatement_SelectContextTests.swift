import XCTest
import Statement
import StatementSQLite

final class SQLiteStatement_SelectContextTests: XCTestCase {
    
    @available(*, deprecated)
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
    
    func testSelectFromTable() throws {
        let id = try XCTUnwrap(CatalogExpression["id"])
        let name = try XCTUnwrap(CatalogExpression["name"])
        let defaultLanguage = try XCTUnwrap(CatalogExpression["default_language"])
        let comment = try XCTUnwrap(CatalogExpression["comment"])
        let feature = try XCTUnwrap(CatalogExpression["feature"])
        
        let statement: SQLiteStatement = .init(
            .SELECT(
                .attribute(id),
                .attribute(name),
                .attribute(defaultLanguage),
                .attribute(comment),
                .attribute(feature)
            ),
            .FROM_TABLE(CatalogExpression.self)
        )
        
        XCTAssertEqual(statement.render(), """
        SELECT id, name, default_language, comment, feature
        FROM expression;
        """)
    }
    
    func testSelectFromWhere() throws {
        let id = try XCTUnwrap(CatalogExpression["id"])
        let name = try XCTUnwrap(CatalogExpression["name"])
        let defaultLanguage = try XCTUnwrap(CatalogExpression["default_language"])
        let comment = try XCTUnwrap(CatalogExpression["comment"])
        let feature = try XCTUnwrap(CatalogExpression["feature"])
        
        let statement: SQLiteStatement = .init(
            .SELECT(
                .attribute(CatalogExpression.self, attribute: id),
                .attribute(name),
                .attribute(defaultLanguage),
                .attribute(comment),
                .attribute(feature)
            ),
            .FROM(
                .TABLE(CatalogExpression.self)
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
        let id = try XCTUnwrap(CatalogExpression["id"])
        let name = try XCTUnwrap(CatalogExpression["name"])
        let defaultLanguage = try XCTUnwrap(CatalogExpression["default_language"])
        let comment = try XCTUnwrap(CatalogExpression["comment"])
        let feature = try XCTUnwrap(CatalogExpression["feature"])
        
        let expressionId = try XCTUnwrap(CatalogTranslation["expression_id"])
        let language = try XCTUnwrap(CatalogTranslation["language_code"])
        let region = try XCTUnwrap(CatalogTranslation["region_code"])
        
        let statement: SQLiteStatement = .init(
            .SELECT(
                .attribute(CatalogExpression.self, attribute: id),
                .attribute(name),
                .attribute(defaultLanguage),
                .attribute(comment),
                .attribute(feature)
            ),
            .FROM(
                .TABLE(CatalogExpression.self),
                .JOIN_ON(CatalogTranslation.self, attribute: expressionId, on: CatalogExpression.self, equals: id)
            ),
            .WHERE(
                .AND(
                    .column(language, entity: CatalogTranslation(), op: .equal, value: "en"),
                    .column(region, entity: CatalogTranslation(), op: .equal, value: "US")
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
