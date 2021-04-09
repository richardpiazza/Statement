import XCTest
import Statement
import StatementSQLite

final class SQLiteStatementTests: XCTestCase {
    
    static var allTests = [
        ("testSelect", testSelect),
    ]
    
    func testSelect() {
        let statement = SQLiteStatement(
            .SELECT(
                .column(Expression.id, tablePrefix: true),
                .column(Expression.name),
                .column(Expression.defaultLanguage),
                .column(Expression.comment),
                .column(Expression.feature)
            ),
            .FROM_TABLE(Expression.self),
            .JOIN_TABLE(Translation.self, on: Expression.id, equals: Translation.expressionID),
            .WHERE(
                .AND(
                    .comparison(Translation.language, .equal("en")),
                    .comparison(Translation.region, .equal("US"))
                )
            ),
            .LIMIT(1)
        )
        
        XCTAssertEqual(statement.render(), """
        SELECT expression.id, name, default_language, comment, feature
        FROM expression
        JOIN translation ON expression.id = translation.expression_id
        WHERE translation.language_code = 'en' AND translation.region_code = 'US'
        LIMIT 1;
        """)
    }
    
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
    
    func testInsert() {
        let statement = SQLiteStatement(
            .INSERT_INTO_TABLE(
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
    }
    
    func testCreate() {
        let statement = SQLiteStatement(
            .CREATE(
                .SCHEMA(Translation.self, ifNotExists: true)
            )
        )
        
        XCTAssertEqual(statement.render(), """
        CREATE TABLE IF NOT EXISTS translation ( id INTEGER NOT NULL UNIQUE,
        expression_id INTEGER NOT NULL,
        language_code TEXT NOT NULL,
        region_code TEXT,
        value TEXT NOT NULL,
        PRIMARY KEY ( id AUTOINCREMENT ),
        FOREIGN KEY ( expression_id ) REFERENCES expression ( id ) );
        """)
    }
    
    func testAlterContext() {
        var statement: SQLiteStatement
        var render: String
        
        statement = .init(
            .ALTER(
                .keyword(.table),
                .table(Translation.self),
                .RENAME_TO(Expression.self)
            )
        )
        
        render = statement.render()
        XCTAssertEqual(render, """
        ALTER TABLE translation RENAME TO expression;
        """)
        
        statement = .init(
            .ALTER_TABLE(
                Translation.self,
                .RENAME_TO(Expression.self)
            )
        )
        
        render = statement.render()
        XCTAssertEqual(render, """
        ALTER TABLE translation RENAME TO expression;
        """)
        
        statement = .init(
            .ALTER_TABLE(
                Translation.self,
                .RENAME_COLUMN(Translation.language, to: Translation.region)
            )
        )
        
        render = statement.render()
        XCTAssertEqual(render, """
        ALTER TABLE translation RENAME COLUMN language_code TO region_code;
        """)
        
        statement = .init(
            .ALTER_TABLE(
                Translation.self,
                .ADD_COLUMN(Translation.language)
            )
        )
        
        render = statement.render()
        XCTAssertEqual(render, """
        ALTER TABLE translation ADD COLUMN language_code TEXT NOT NULL;
        """)
        
        statement = .init(
            .ALTER_TABLE(
                Translation.self,
                .DROP_COLUMN(Translation.language)
            )
        )
        
        render = statement.render()
        XCTAssertEqual(render, """
        ALTER TABLE translation DROP COLUMN language_code;
        """)
    }
}
