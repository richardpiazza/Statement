import Statement
import StatementSQLite
import Testing

struct SQLiteStatement_DeleteContextTests {

    @Test func testDeleteFrom() {
        let statement: SQLiteStatement = SQLiteStatement(
            .DELETE(
                .FROM(Expression.self),
            ),
        )

        #expect(statement.render() == "DELETE FROM expression;")
    }

    @Test func testDeleteWhere() throws {
        let entity = Expression()
        let id = try #require(entity["id"])

        var statement: SQLiteStatement = SQLiteStatement(
            .DELETE(
                .FROM(Expression.self),
            ),
            .WHERE(
                .column(id, op: .equal, value: 123),
            ),
        )

        #expect(statement.render() == """
        DELETE FROM expression
        WHERE id = 123;
        """)

        statement = SQLiteStatement(
            .DELETE(
                .FROM(Expression.self),
            ),
            .WHERE(
                .column(Expression.self, attribute: id, op: .equal, value: 123),
            ),
        )

        #expect(statement.render() == """
        DELETE FROM expression
        WHERE expression.id = 123;
        """)
    }
}
