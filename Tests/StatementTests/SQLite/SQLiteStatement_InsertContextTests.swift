import XCTest
import Statement
import StatementSQLite

final class SQLiteStatement_InsertContextTests: XCTestCase {
    
    func testInsertInto() throws {
        let entity = Translation()
        let language = try XCTUnwrap(entity["language_code"])
        let region = try XCTUnwrap(entity["region_code"])
        
        var statement: SQLiteStatement = .init(
            .INSERT_INTO(
                Translation.self,
                .column(language),
                .column(region)
            ),
            .VALUES(
                .value(LanguageCode.en.rawValue as DataTypeConvertible),
                .value(RegionCode.US.rawValue as DataTypeConvertible)
            )
        )
        
        XCTAssertEqual(statement.render(), """
        INSERT INTO translation ( language_code, region_code )
        VALUES ( 'en', 'US' );
        """)
        
        let expressionEntity = Expression()
        let name = try XCTUnwrap(expressionEntity["name"])
        let comment = try XCTUnwrap(expressionEntity["comment"])
        
        statement = .init(
            .INSERT(
                .OR_ROLLBACK,
                .INTO(Expression.self),
                .group(segments: [
                    Segment<SQLiteStatement.InsertContext>.attribute(name),
                    .column(comment)
                ])
            )
        )
        
        XCTAssertEqual(statement.render(), """
        INSERT OR ROLLBACK INTO expression ( name, comment );
        """)
    }
}
