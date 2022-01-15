import XCTest
import Statement
import StatementSQLite

final class SQLiteStatement_AlterContextTests: XCTestCase {
    
    func testAlterTableRenameTo() {
        let statement = SQLiteStatement(
            .ALTER_TABLE(
                Translation.self,
                .RENAME_TO(Expression.self)
            )
        )
        
        XCTAssertEqual(statement.render(), """
        ALTER TABLE translation RENAME TO expression;
        """)
    }
    
    func testAlterTableRenameColumn() throws {
        let entity = Translation()
        let language = try XCTUnwrap(entity["language_code"])
        let region = try XCTUnwrap(entity["region_code"])
        
        let statement = SQLiteStatement(
            .ALTER_TABLE(
                Translation.self,
                .RENAME_COLUMN(language, to: region)
            )
        )
        
        XCTAssertEqual(statement.render(), """
        ALTER TABLE translation RENAME COLUMN language_code TO region_code;
        """)
    }
    
    func testAlterTableAddColumn() throws {
        let entity = Translation()
        let language = try XCTUnwrap(entity["language_code"])
        
        let statement = SQLiteStatement(
            .ALTER_TABLE(
                Translation.self,
                .ADD_COLUMN(language)
            )
        )
        
        XCTAssertEqual(statement.render(), """
        ALTER TABLE translation ADD COLUMN language_code TEXT NOT NULL DEFAULT 'en';
        """)
    }
    
    func testAlterTableDropColumn() throws {
        let entity = Translation()
        let language = try XCTUnwrap(entity["language_code"])
        
        let statement = SQLiteStatement(
            .ALTER_TABLE(
                Translation.self,
                .DROP_COLUMN(language)
            )
        )
        
        XCTAssertEqual(statement.render(), """
        ALTER TABLE translation DROP COLUMN language_code;
        """)
    }
}
