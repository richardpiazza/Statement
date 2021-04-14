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
                .column(Translation.value, op: .equal, value: "Corrected Translation"),
                .column(Translation.region, op: .equal, value: NSNull())
            ),
            .WHERE(
                .column(Translation.id, op: .equal, value: 123)
            )
        )
        
        XCTAssertEqual(statement.render(), """
        UPDATE translation
        SET translation.value = 'Corrected Translation', translation.region_code = NULL
        WHERE translation.id = 123;
        """)
    }
}
