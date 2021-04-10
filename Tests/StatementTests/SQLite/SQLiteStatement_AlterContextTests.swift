import XCTest
import Statement
import StatementSQLite

final class SQLiteStatement_AlterContextTests: XCTestCase {
    
    static var allTests = [
        ("testRenameTable", testRenameTable),
        ("testRenameColumn", testRenameColumn),
        ("testAddColumn", testAddColumn),
        ("testDropColumn", testDropColumn),
    ]
    
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
}
