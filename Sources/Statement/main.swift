import Foundation

let statement = SQLiteStatement(
    .SELECT(
        .column(Expression.Schema.id),
        .column(Expression.Schema.name),
        .column(Expression.Schema.defaultLanguage),
        .column(Expression.Schema.comment),
        .column(Expression.Schema.feature)
    ),
    .FROM(Expression.self),
    .JOIN(Translation.self, on: Expression.Schema.id, equals: Translation.Schema.expressionID),
    .WHERE(
        .AND(
            .expression(Translation.Schema.language, .equal("en")),
            .expression(Translation.Schema.region, .equal("US"))
        )
    ),
    .LIMIT(1)
)

print(statement.render())
print("")

let update = SQLiteStatement(
    .UPDATE(Translation.self),
    .SET(
        .expression(Translation.Schema.value, .equal("Corrected Translation")),
        .expression(Translation.Schema.region, .equal(NSNull()))
    ),
    .WHERE(
        .expression(Translation.Schema.id, .equal(123))
    )
)

print(update.render())
print("")

let insert = SQLiteStatement(
    .INSERT_INTO(
        Translation.self,
        .column(Translation.Schema.language),
        .column(Translation.Schema.region)
    ),
    .VALUES(
        .value(LanguageCode.en.rawValue),
        .value(RegionCode.US.rawValue)
    )
)

print(insert.render())
print("")

let create = SQLiteStatement(
    .CREATE(
        .TABLE(
            Translation.self,
            ifNotExists: true,
            segments:
            .COLUMN(Translation.Schema.id, dataType: .integer, notNull: true, unique: true),
            .COLUMN(Translation.Schema.expressionID, dataType: .integer, notNull: true),
            .COLUMN(Translation.Schema.language, dataType: .text, notNull: true),
            .COLUMN(Translation.Schema.region, dataType: .text),
            .COLUMN(Translation.Schema.value, dataType: .text, notNull: true),
            .PRIMARY_KEY(Translation.Schema.id, autoIncrement: true),
            .FOREIGN_KEY(Translation.Schema.expressionID, references: Expression.Schema.id)
        )
    )
)

print(create.render())
print("")
