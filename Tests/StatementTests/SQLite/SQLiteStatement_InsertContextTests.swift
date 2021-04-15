import XCTest
import Statement
import StatementSQLite

final class SQLiteStatement_InsertContextTests: XCTestCase {
    
    static var allTests = [
        ("testInsert", testInsert),
    ]
    
    func testInsert() {
        let statement = SQLiteStatement(
            .INSERT_INTO_TABLE(
                Translation.self,
                .column(Translation.language),
                .column(Translation.region)
            ),
            .VALUES(
                .value(LanguageCode.en.rawValue),
                .value(RegionCode.US.rawValue)
            )
        )
        
        XCTAssertEqual(statement.render(), """
        INSERT INTO translation ( language_code, region_code )
        VALUES ( 'en', 'US' );
        """)
    }
}
