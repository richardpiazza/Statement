import XCTest
import Statement
import StatementSQLite

final class SQLiteStatement_AlterContextTests: XCTestCase {
    
    @available(*, deprecated)
    func testRenameTable() {
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
    
    func testAlterTableRenameTo() {
        let statement = SQLiteStatement(
            .ALTER_TABLE(
                CatalogTranslation.self,
                .RENAME_TO(CatalogExpression.self)
            )
        )
        
        XCTAssertEqual(statement.render(), """
        ALTER TABLE translation RENAME TO expression;
        """)
    }
    
    @available(*, deprecated)
    func testRenameColumn() {
        let statement = SQLiteStatement(
            .ALTER_TABLE(
                Translation.self,
                .RENAME_COLUMN(Translation.language, to: Translation.region)
            )
        )
        
        XCTAssertEqual(statement.render(), """
        ALTER TABLE translation RENAME COLUMN language_code TO region_code;
        """)
    }
    
    func testAlterTableRenameColumn() throws {
        let language = try XCTUnwrap(CatalogTranslation["language_code"])
        let region = try XCTUnwrap(CatalogTranslation["region_code"])
        
        let statement = SQLiteStatement(
            .ALTER_TABLE(
                CatalogTranslation.self,
                .RENAME_COLUMN(language, to: region)
            )
        )
        
        XCTAssertEqual(statement.render(), """
        ALTER TABLE translation RENAME COLUMN language_code TO region_code;
        """)
    }
    
    @available(*, deprecated)
    func testAddColumn() {
        let statement = SQLiteStatement(
            .ALTER_TABLE(
                Translation.self,
                .ADD_COLUMN(Translation.language)
            )
        )
        
        XCTAssertEqual(statement.render(), """
        ALTER TABLE translation ADD COLUMN language_code TEXT NOT NULL;
        """)
    }
    
    func testAlterTableAddColumn() throws {
        let language = try XCTUnwrap(CatalogTranslation["language_code"])
        
        let statement = SQLiteStatement(
            .ALTER_TABLE(
                CatalogTranslation.self,
                .ADD_COLUMN(language)
            )
        )
        
        XCTAssertEqual(statement.render(), """
        ALTER TABLE translation ADD COLUMN language_code TEXT NOT NULL DEFAULT 'en';
        """)
    }
    
    @available(*, deprecated)
    func testDropColumn() {
        let statement = SQLiteStatement(
            .ALTER_TABLE(
                Translation.self,
                .DROP_COLUMN(Translation.language)
            )
        )
        
        XCTAssertEqual(statement.render(), """
        ALTER TABLE translation DROP COLUMN language_code;
        """)
    }
    
    func testAlterTableDropColumn() throws {
        let language = try XCTUnwrap(CatalogTranslation["language_code"])
        
        let statement = SQLiteStatement(
            .ALTER_TABLE(
                CatalogTranslation.self,
                .DROP_COLUMN(language)
            )
        )
        
        XCTAssertEqual(statement.render(), """
        ALTER TABLE translation DROP COLUMN language_code;
        """)
    }
}
