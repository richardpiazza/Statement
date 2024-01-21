# Statement

Swift DSL for writing SQL statements.

<p>
    <img src="https://github.com/richardpiazza/Statement/workflows/Swift/badge.svg?branch=main" />
    <img src="https://img.shields.io/badge/Swift-5.3-orange.svg" />
</p>

## Using Swift to write SQL 🤯

```swift
let expressionId: Int = 123
let languageCode: LanguageCode? = .en
let regionCode: RegionCode? = .us

let statement = SQLiteStatement(
    .SELECT(
        .column(Translation["id"]!),
        .column(Translation["expression_id"]!),
        .column(Translation["language_code"]!),
        .column(Translation["region_code"]!),
        .column(Translation["value"]!)
    ),
    .FROM_TABLE(Translation.self),
    .WHERE(
        .AND(
            .comparison(Translation.expressionID, .equal(expressionID)),
            .unwrap(languageCode, transform: { .comparison(Translation["language_code"]!, .equal($0.rawValue)) }),
            .unwrap(regionCode, transform: { .comparison(Translation["region_code"]!, .equal($0.rawValue)) }),
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

But take a closer look at the elements provided in the `.AND` block. The `languageCode` & `regionCode` are both optionals, and there is an 
additional logical element clause when one is nil. With all of the optionals and logic, there is a possibility of producing 4 separate **where** 
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
struct Translation: Entity, Identifiable {

    let tableName: String = "translation"

    /// Unique/Primary Key
    @Field("id", unique: true, primaryKey: true, autoIncrement: true)
    var id: Int = 0

    /// Expression (Foreign Key)
    @Field("expression_id", foreignKey: .init("expression", "id"))
    var expressionID: Expression.ID = 0

    /// Language of the translation
    @Field("language_code")
    var language: String = LanguageCode.default.rawValue

    /// Region code specifier
    @Field("region_code")
    var region: String? = nil

    /// The translated string
    @Field("value")
    var value: String = ""
}
```

### Automagical Epoxy

Using the Swift reflection api `Mirror`, the `@Field` property's are automatically synthesized.

```swift
extension Entity {
    var attributes: [Attribute] {
        var _columns: [Attribute] = []
        
        let mirror = Mirror(reflecting: self)
        for child in mirror.children {
            if let column = child.value as? AttributeConvertible {
                _columns.append(column.attribute)
            } else if let column = child.value as? Attribute {
                _columns.append(column)
            }
        }
        
        return _columns
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
        .package(url: "https://github.com/richardpiazza/Statement.git", .upToNextMinor(from: "0.7.2")
    ],
    ...
)
```

Then import the **Statement** packages wherever you'd like to use it:

```swift
import Statement
```
