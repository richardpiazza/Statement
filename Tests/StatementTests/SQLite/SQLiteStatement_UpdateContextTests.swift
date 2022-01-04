import XCTest
import Statement
import StatementSQLite

final class SQLiteStatement_UpdateContextTests: XCTestCase {
    
    @available(*, deprecated)
    func testUpdate() {
        var statement: SQLiteStatement = .init(
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
        SET value = 'Corrected Translation', region_code = NULL
        WHERE id = 123;
        """)
        
        statement = .init(
            .UPDATE_TABLE(Translation.self),
            .SET(
                .column(Translation.value, op: .equal, value: "Corrected Translation"),
                .column(Translation.region, op: .equal, value: NSNull())
            ),
            .WHERE(
                .column(Translation.value, op: .like, value: "%bob%")
            )
        )
        
        XCTAssertEqual(statement.render(), """
        UPDATE translation
        SET value = 'Corrected Translation', region_code = NULL
        WHERE value LIKE '%bob%';
        """)
    }
    
    func testUpdateTable() throws {
        let value = try XCTUnwrap(CatalogTranslation["value"])
        let region = try XCTUnwrap(CatalogTranslation["region_code"])
        let id = try XCTUnwrap(CatalogTranslation["id"])
        
        let nullRegion: String? = nil
        
        var statement: SQLiteStatement = .init(
            .UPDATE_TABLE(CatalogTranslation.self),
            .SET(
                .attribute(value, op: .equal, value: "Corrected Translation"),
                .attribute(region, op: .equal, value: nullRegion)
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
            .UPDATE_TABLE(CatalogTranslation.self),
            .SET(
                .attribute(value, op: .equal, value: "Corrected Translation"),
                .attribute(region, op: .equal, value: nullRegion)
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
