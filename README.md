# Statement

Swift DSL for writing SQL statements.

<p>
    <img src="https://github.com/richardpiazza/Statement/workflows/Swift/badge.svg?branch=main" />
    <img src="https://img.shields.io/badge/Swift-5.3-orange.svg" />
    <a href="https://twitter.com/richardpiazza">
        <img src="https://img.shields.io/badge/twitter-@richardpiazza-blue.svg?style=flat" alt="Twitter: @richardpiazza" />
    </a>
</p>

## Using Swift to write SQL 🤯

```swift
let statement = SQLiteStatement(
    .SELECT(
        .column(Translation.id),
        .column(Translation.expressionID),
        .column(Translation.language),
        .column(Translation.region),
        .column(Translation.value)
    ),
    .FROM_TABLE(Translation.self),
    .WHERE(
        .AND(
            .comparison(Translation.expressionID, .equal(expressionID)),
            .unwrap(languageCode, transform: { .comparison(Translation.language, .equal($0.rawValue)) }),
            .unwrap(regionCode, transform: { .comparison(Translation.region, .equal($0.rawValue)) }),
            .if(languageCode != nil && regionCode == nil, .logical(Translation.region, .isNull))
        )
    )
)
```

The first part of the _statement_ is rather clear:

```sql
SELECT translation.id, translation.expression_id, translation.language_code, translation.region_code, translation.value
FROM translation
...
```

But take a closer look at the elements provided in the `.AND` block. The `lanugageCode` & `regionCode` are both optionals, and there is an 
additional logical element clause when one is nil. With all of the optionals and logic, there are a possibilty of producing 4 separate **where** 
clauses.

```sql
WHERE translation.expression_id = 123
---
WHERE translation.expression_id = 123 AND translation.language_code = 'en' AND translation.region_code IS NULL
---
WHERE translation.expression_id = 123 AND translation.region_code = 'US'
---
WHERE translation.expression_id = 123 AND translation.language_code = 'en' AND translation.region_code = 'US'
```

## Type-Safe Magic

```swift
public struct Translation: Identifiable {

    public enum CodingKeys: String, CodingKey {
        case id
        case expressionID = "expression_id"
        case language = "language_code"
        case region = "region_code"
        case value
    }

    /// Unique/Primary Key
    @Column(key: .id, notNull: true, unique: true, primaryKey: true, autoIncrement: true)
    public var id: Int = 0

    /// Expression (Foreign Key)
    @Column(key: .expressionID, notNull: true, foreignKey: Expression.id)
    public var expressionID: Expression.ID = 0

    /// Language of the translation
    @Column(key: .language, notNull: true)
    public var language: String = LanguageCode.default.rawValue

    /// Region code specifier
    @Column(key: .region)
    public var region: String? = nil

    /// The translated string
    @Column(key: .value, notNull: true)
    public var value: String = ""
}
```

### Automagical Epoxy

```swift
extension Translation {
    internal var schema: Schema {
        return Schema(
            name: "translation",
            columns: [_id, _expressionID, _language, _region, _value]
        )
    }
    
    public static var schema: Schema = { Translation().schema }()
    
    static var id: AnyColumn = { schema[.id] }()
    static var expressionID: AnyColumn = { schema[.expressionID] }()
    static var language: AnyColumn = { schema[.language] }()
    static var region: AnyColumn = { schema[.region] }()
    static var value: AnyColumn = { schema[.value] }()
}

private extension Schema {
    subscript(codingKey: Translation.CodingKeys) -> AnyColumn {
        guard let column = columns.first(where: { $0.name == codingKey.stringValue }) else {
            preconditionFailure("Invalid column name '\(codingKey.stringValue)'.")
        }
        
        return column
    }
}
```

## Installation

**Statement** is distributed using the [Swift Package Manager](https://swift.org/package-manager).
To install it into a project, add it as a dependency within your `Package.swift` manifest:

```swift
let package = Package(
    ...
    dependencies: [
        .package(url: "https://github.com/richardpiazza/Statement.git", .upToNextMinor(from: "0.1.0")
    ],
    ...
)
```

Then import the **Statement** packages wherever you'd like to use it:

```swift
import Statement
```
