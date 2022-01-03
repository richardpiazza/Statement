import XCTest
import Statement
import StatementSQLite

final class SQLiteStatement_InsertContextTests: XCTestCase {
    
    @available(*, deprecated)
    func testInsert() {
        var statement: SQLiteStatement = .init(
            .INSERT_INTO(
                Translation.self,
                .column(Translation.language),
                .column(Translation.region)
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
    
    func testInsertInto() throws {
        let language = try XCTUnwrap(CatalogTranslation["language_code"])
        let region = try XCTUnwrap(CatalogTranslation["region_code"])
        
        var statement: SQLiteStatement = .init(
            .INSERT_INTO(
                CatalogTranslation.self,
                .attribute(language),
                .attribute(region)
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
        
        let name = try XCTUnwrap(CatalogExpression["name"])
        let comment = try XCTUnwrap(CatalogExpression["comment"])
        
        statement = .init(
            .INSERT(
                .OR_ROLLBACK,
                .INTO(CatalogExpression.self),
                .group(segments: [
                    Segment<SQLiteStatement.InsertContext>.attribute(name),
                    .attribute(comment)
                ])
            )
        )
        
        XCTAssertEqual(statement.render(), """
        INSERT OR ROLLBACK INTO expression ( name, comment );
        """)
    }
}
