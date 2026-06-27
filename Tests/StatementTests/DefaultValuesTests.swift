import Statement
import StatementSQLite
import Testing

struct DefaultValuesTests {

    struct RelationalEntity: Statement.Entity {
        static let identifier: String = "entity"
        let tableName: String = "entity"
        @Field("rating") var rating: Int? = nil
        var ratingDescription: String { _rating.description }
    }

    @Test func testNullableDefaultValue() {
        let statement = SQLiteStatement(
            .CREATE(
                .SCHEMA(
                    RelationalEntity(),
                ),
            ),
        )
        #expect(statement.render() == """
        CREATE TABLE IF NOT EXISTS entity ( rating INTEGER DEFAULT NULL );
        """)
    }

    @Test func testColumnDescription() {
        var table = RelationalEntity()
        table.rating = 45
        #expect(table.ratingDescription == """
        rating INTEGER DEFAULT NULL VALUE: 45
        """)
    }
}
