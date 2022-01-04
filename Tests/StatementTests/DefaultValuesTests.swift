import XCTest
import Statement
import StatementSQLite

final class DefaultValuesTests: XCTestCase {
    
    @available(*, deprecated)
    private struct Entity: Table {
        
        private var schema: Schema {
            .init(name: "entity", columns: [_rating])
        }
        
        static var schema: Schema { Entity().schema }
        
        @Column(table: Self.self, name: "rating", dataType: "INTEGER", provideDefault: true)
        var rating: Int? = nil
        
        var ratingDescription: String { _rating.description }
    }
    
    @available(*, deprecated)
    func testOptionalDefault() {
        let statement = SQLiteStatement(.CREATE(.SCHEMA(Entity.self)))
        XCTAssertEqual(statement.render(), """
        CREATE TABLE IF NOT EXISTS entity ( rating INTEGER DEFAULT NULL );
        """)
    }
    
    @available(*, deprecated)
    func testDescription() {
        var entity = Entity()
        entity.rating = 45
        
        XCTAssertEqual(entity.ratingDescription, """
        rating INTEGER DEFAULT NULL VALUE: 45
        """)
    }
    
    struct RelationalEntity: Statement.Entity {
        let tableName: String = "entity"
        @Field("rating") var rating: Int? = nil
        var ratingDescription: String { _rating.description }
    }
    
    func testNullableDefaultValue() {
        let statement = SQLiteStatement(.CREATE(.SCHEMA(RelationalEntity.self)))
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
