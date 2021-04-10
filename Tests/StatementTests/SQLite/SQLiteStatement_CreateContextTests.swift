import XCTest
import Statement
import StatementSQLite

final class SQLiteStatement_CreateContextTests: XCTestCase {
    
    static var allTests = [
        ("testCreate", testCreate),
    ]
    
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
}
