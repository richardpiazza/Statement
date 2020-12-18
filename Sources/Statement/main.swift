import Foundation

let statement = SQLiteStatement(
    .SELECT(
        .column(Expression.Schema.id),
        .column(Expression.Schema.name),
        .column(Expression.Schema.defaultLanguage),
        .column(Expression.Schema.comment),
        .column(Expression.Schema.feature)
    ),
    .FROM(
        .table(Expression.self)
    ),
    .JOIN(
        .table(Translation.self),
        .ON(Expression.Schema.id, Translation.Schema.expressionID)
    ),
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
    .UPDATE(
        .table(Translation.self)
    ),
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
