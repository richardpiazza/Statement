import XCTest
import Statement
import StatementSQLite

final class SQLiteStatement_UpdateContextTests: XCTestCase {
    
    static var allTests = [
        ("testUpdate", testUpdate),
    ]
    
    func testUpdate() {
        let statement = SQLiteStatement(
            .UPDATE_TABLE(Translation.self),
            .SET(
                .comparison(Translation.value, .equal("Corrected Translation")),
                .comparison(Translation.region, .equal(NSNull()))
            ),
            .WHERE(
                .comparison(Translation.id, .equal(123))
            )
        )
        
        XCTAssertEqual(statement.render(), """
        UPDATE translation
        SET translation.value = 'Corrected Translation', translation.region_code = NULL
        WHERE translation.id = 123;
        """)
    }
}
