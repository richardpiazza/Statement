import Statement
import StatementSQLite
import Testing

struct SQLiteStatement_UpdateContextTests {

    @Test func testUpdateTable() throws {
        let entity = Translation()
        let value = try #require(entity["value"])
        let region = try #require(entity["region_code"])
        let id = try #require(entity["id"])

        let nullRegion: String? = nil

        var statement: SQLiteStatement = SQLiteStatement(
            .UPDATE_TABLE(Translation.self),
            .SET(
                .column(value, op: .equal, value: "Corrected Translation"),
                .column(region, op: .equal, value: nullRegion),
            ),
            .WHERE(
                .column(id, op: .equal, value: 123),
            ),
        )

        #expect(statement.render() == """
        UPDATE translation
        SET value = 'Corrected Translation', region_code = NULL
        WHERE id = 123;
        """)

        statement = SQLiteStatement(
            .UPDATE_TABLE(Translation.self),
            .SET(
                .column(value, op: .equal, value: "Corrected Translation"),
                .column(region, op: .equal, value: nullRegion),
            ),
            .WHERE(
                .column(value, op: .like, value: "%bob%"),
            ),
        )

        #expect(statement.render() == """
        UPDATE translation
        SET value = 'Corrected Translation', region_code = NULL
        WHERE value LIKE '%bob%';
        """)
    }
}
