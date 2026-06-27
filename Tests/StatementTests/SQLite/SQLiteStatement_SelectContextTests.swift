import Statement
import StatementSQLite
import Testing

struct SQLiteStatement_SelectContextTests {

    @Test func testSelectFromTable() throws {
        let entity = Expression()
        let id = try #require(entity["id"])
        let name = try #require(entity["name"])
        let defaultLanguage = try #require(entity["default_language"])
        let comment = try #require(entity["comment"])
        let feature = try #require(entity["feature"])

        let statement: SQLiteStatement = SQLiteStatement(
            .SELECT(
                .column(id),
                .column(name),
                .column(defaultLanguage),
                .column(comment),
                .column(feature),
            ),
            .FROM_TABLE(Expression.self),
        )

        #expect(statement.render() == """
        SELECT id, name, default_language, comment, feature
        FROM expression;
        """)
    }

    @Test func testSelectFromWhere() throws {
        let entity = Expression()
        let id = try #require(entity["id"])
        let name = try #require(entity["name"])
        let defaultLanguage = try #require(entity["default_language"])
        let comment = try #require(entity["comment"])
        let feature = try #require(entity["feature"])

        let statement: SQLiteStatement = SQLiteStatement(
            .SELECT(
                .column(Expression.self, attribute: id),
                .column(name),
                .column(defaultLanguage),
                .column(comment),
                .column(feature),
            ),
            .FROM(
                .TABLE(Expression.self),
            ),
            .WHERE(
                .column(name, op: .equal, value: "Setup"),
            ),
        )

        #expect(statement.render() == """
        SELECT expression.id, name, default_language, comment, feature
        FROM expression
        WHERE name = 'Setup';
        """)
    }

    @Test func testSelectFromWhereLimit() throws {
        let expressionEntity = Expression()
        let id = try #require(expressionEntity["id"])
        let name = try #require(expressionEntity["name"])
        let defaultLanguage = try #require(expressionEntity["default_language"])
        let comment = try #require(expressionEntity["comment"])
        let feature = try #require(expressionEntity["feature"])

        let translationEntity = Translation()
        let expressionId = try #require(translationEntity["expression_id"])
        let language = try #require(translationEntity["language_code"])
        let region = try #require(translationEntity["region_code"])

        let statement: SQLiteStatement = SQLiteStatement(
            .SELECT(
                .attribute(Expression.self, attribute: id),
                .attribute(name),
                .attribute(defaultLanguage),
                .attribute(comment),
                .attribute(feature),
            ),
            .FROM(
                .TABLE(Expression.self),
                .JOIN_ON(Translation.self, attribute: expressionId, equals: Expression.self, attribute: id),
            ),
            .WHERE(
                .AND(
                    .column(language, entity: Translation(), op: .equal, value: "en"),
                    .column(region, entity: Translation(), op: .equal, value: "US"),
                ),
            ),
            .LIMIT(1),
        )

        #expect(statement.render() == """
        SELECT expression.id, name, default_language, comment, feature
        FROM expression JOIN translation ON translation.expression_id = expression.id
        WHERE translation.language_code = 'en' AND translation.region_code = 'US'
        LIMIT 1;
        """)
    }
}
