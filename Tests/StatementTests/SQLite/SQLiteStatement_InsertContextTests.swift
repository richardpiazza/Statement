import XCTest
import Statement
import StatementSQLite

final class SQLiteStatement_InsertContextTests: XCTestCase {
    
    static var allTests = [
        ("testInsert", testInsert),
    ]
    
    func testInsert() {
        var statement: SQLiteStatement = .init(
            .INSERT_INTO(
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
        
        statement = .init(
            .INSERT(
                .OR_ROLLBACK,
                .INTO(Expression.self),
                .group(segments: [
                    Segment<SQLiteStatement.InsertContext>.column(Expression.name),
                    .column(Expression.comment)
                ])
            )
        )
        
        XCTAssertEqual(statement.render(), """
        INSERT OR ROLLBACK INTO expression ( name, comment );
        """)
    }
}
