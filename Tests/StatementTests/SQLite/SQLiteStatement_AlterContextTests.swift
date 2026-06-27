import Statement
import StatementSQLite
import Testing

struct SQLiteStatement_AlterContextTests {

    @Test func testAlterTableRenameTo() {
        let statement = SQLiteStatement(
            .ALTER_TABLE(
                Translation.self,
                .RENAME_TO(Expression.self),
            ),
        )

        #expect(statement.render() == """
        ALTER TABLE translation RENAME TO expression;
        """)
    }

    @Test func testAlterTableRenameColumn() throws {
        let entity = Translation()
        let language = try #require(entity["language_code"])
        let region = try #require(entity["region_code"])

        let statement = SQLiteStatement(
            .ALTER_TABLE(
                Translation.self,
                .RENAME_COLUMN(language, to: region),
            ),
        )

        #expect(statement.render() == """
        ALTER TABLE translation RENAME COLUMN language_code TO region_code;
        """)
    }

    @Test func testAlterTableAddColumn() throws {
        let entity = Translation()
        let language = try #require(entity["language_code"])

        let statement = SQLiteStatement(
            .ALTER_TABLE(
                Translation.self,
                .ADD_COLUMN(language),
            ),
        )

        #expect(statement.render() == """
        ALTER TABLE translation ADD COLUMN language_code TEXT NOT NULL DEFAULT 'en';
        """)
    }

    @Test func testAlterTableDropColumn() throws {
        let entity = Translation()
        let language = try #require(entity["language_code"])

        let statement = SQLiteStatement(
            .ALTER_TABLE(
                Translation.self,
                .DROP_COLUMN(language),
            ),
        )

        #expect(statement.render() == """
        ALTER TABLE translation DROP COLUMN language_code;
        """)
    }
}
