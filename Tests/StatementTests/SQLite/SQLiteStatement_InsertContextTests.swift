import Statement
import StatementSQLite
import Testing

struct SQLiteStatement_InsertContextTests {

    @Test func testInsertInto() throws {
        let entity = Translation()
        let language = try #require(entity["language_code"])
        let region = try #require(entity["region_code"])

        var statement: SQLiteStatement = SQLiteStatement(
            .INSERT_INTO(
                Translation.self,
                .column(language),
                .column(region),
            ),
            .VALUES(
                .value(LanguageCode.en.rawValue as any DataTypeConvertible),
                .value(RegionCode.US.rawValue as any DataTypeConvertible),
            ),
        )

        #expect(statement.render() == """
        INSERT INTO translation ( language_code, region_code )
        VALUES ( 'en', 'US' );
        """)

        let expressionEntity = Expression()
        let name = try #require(expressionEntity["name"])
        let comment = try #require(expressionEntity["comment"])

        statement = SQLiteStatement(
            .INSERT(
                .OR_ROLLBACK,
                .INTO(Expression.self),
                .group(segments: [
                    Segment<SQLiteStatement.InsertContext>.attribute(name),
                    .column(comment),
                ]),
            ),
        )

        #expect(statement.render() == """
        INSERT OR ROLLBACK INTO expression ( name, comment );
        """)
    }
}
