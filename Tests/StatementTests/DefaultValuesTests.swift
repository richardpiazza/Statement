import XCTest
import Statement
import StatementSQLite

final class DefaultValuesTests: XCTestCase {
    
    static var allTests = [
        ("testOptionalDefault", testOptionalDefault),
    ]
    
    private struct Entity: Table {
        
        private var schema: Schema {
            .init(name: "entity", columns: [_rating])
        }
        
        static var schema: Schema { Entity().schema }
        
        @Column(table: Self.self, name: "rating", provideDefault: true)
        var rating: Int? = nil
    }
    
    func testOptionalDefault() {
        let statement = SQLiteStatement(.CREATE(.SCHEMA(Entity.self)))
        XCTAssertEqual(statement.render(), """
        CREATE TABLE IF NOT EXISTS entity ( rating INTEGER DEFAULT NULL );
        """)
    }
}
