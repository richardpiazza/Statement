import XCTest
import Statement
import StatementSQLite

final class DefaultValuesTests: XCTestCase {
    
    struct RelationalEntity: Statement.Entity {
        static let identifier: String = "entity"
        let tableName: String = "entity"
        @Field("rating") var rating: Int? = nil
        var ratingDescription: String { _rating.description }
    }
    
    func testNullableDefaultValue() {
        let statement = SQLiteStatement(
            .CREATE(
                .SCHEMA(
                    RelationalEntity()
                )
            )
        )
        XCTAssertEqual(statement.render(), """
        CREATE TABLE IF NOT EXISTS entity ( rating INTEGER DEFAULT NULL );
        """)
    }
    
    func testColumnDescription() {
        var table = RelationalEntity()
        table.rating = 45
        XCTAssertEqual(table.ratingDescription, """
        rating INTEGER DEFAULT NULL VALUE: 45
        """)
    }
}
