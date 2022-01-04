import XCTest
import Statement
import StatementSQLite

final class SQLiteStatement_CreateContextTests: XCTestCase {
    
    @available(*, deprecated)
    func testCreate() {
        let statement = SQLiteStatement(
            .CREATE(
                .SCHEMA(Translation.self, ifNotExists: true)
            )
        )
        
        XCTAssertEqual(statement.render(), """
        CREATE TABLE IF NOT EXISTS translation ( id INTEGER NOT NULL UNIQUE,
        expression_id INTEGER NOT NULL,
        language_code TEXT NOT NULL,
        region_code TEXT,
        value TEXT NOT NULL,
        PRIMARY KEY ( id AUTOINCREMENT ),
        FOREIGN KEY ( expression_id ) REFERENCES expression ( id ) );
        """)
    }
    
    func testCreateSchema() {
        let statement = SQLiteStatement(
            .CREATE(
                .SCHEMA(CatalogTranslation.self, ifNotExists: true)
            )
        )
        
        XCTAssertEqual(statement.render(), """
        CREATE TABLE IF NOT EXISTS translation ( id INTEGER NOT NULL UNIQUE DEFAULT 0,
        expression_id INTEGER NOT NULL DEFAULT 0,
        language_code TEXT NOT NULL DEFAULT 'en',
        region_code TEXT DEFAULT NULL,
        value TEXT NOT NULL DEFAULT '',
        PRIMARY KEY ( id AUTOINCREMENT ),
        FOREIGN KEY ( expression_id ) REFERENCES expression ( id ) );
        """)
    }
}
