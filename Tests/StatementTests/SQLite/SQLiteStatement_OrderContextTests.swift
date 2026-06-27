import Statement
import StatementSQLite
import Testing

struct SQLiteStatement_OrderContextTests {

    @Test func testSelectOrderBy() throws {
        let entity = Expression()
        let name = try #require(entity["name"])

        let statement = SQLiteStatement(
            .SELECT(
                .column(name),
            ),
            .FROM_TABLE(Expression.self),
            .ORDER_BY(
                .column(name, op: .desc),
            ),
        )

        #expect(statement.render() == """
        SELECT name
        FROM expression
        ORDER BY name DESC;
        """)
    }
}
