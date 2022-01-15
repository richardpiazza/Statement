import XCTest
import Statement
import StatementSQLite

final class SQLiteStatement_UpdateContextTests: XCTestCase {
    
    func testUpdateTable() throws {
        let entity = Translation()
        let value = try XCTUnwrap(entity["value"])
        let region = try XCTUnwrap(entity["region_code"])
        let id = try XCTUnwrap(entity["id"])
        
        let nullRegion: String? = nil
        
        var statement: SQLiteStatement = .init(
            .UPDATE_TABLE(Translation.self),
            .SET(
                .column(value, op: .equal, value: "Corrected Translation"),
                .column(region, op: .equal, value: nullRegion)
            ),
            .WHERE(
                .column(id, op: .equal, value: 123)
            )
        )
        
        XCTAssertEqual(statement.render(), """
        UPDATE translation
        SET value = 'Corrected Translation', region_code = NULL
        WHERE id = 123;
        """)
        
        statement = .init(
            .UPDATE_TABLE(Translation.self),
            .SET(
                .column(value, op: .equal, value: "Corrected Translation"),
                .column(region, op: .equal, value: nullRegion)
            ),
            .WHERE(
                .column(value, op: .like, value: "%bob%")
            )
        )
        
        XCTAssertEqual(statement.render(), """
        UPDATE translation
        SET value = 'Corrected Translation', region_code = NULL
        WHERE value LIKE '%bob%';
        """)
    }
}
