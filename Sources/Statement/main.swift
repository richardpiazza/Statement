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
        .on(Expression.Schema.id, Translation.Schema.expressionID)
    ),
    .WHERE(
        .predicate(Translation.Schema.language, .equal("en")),
        .and(
            .predicate(Translation.Schema.region, .equal("US"))
        )
    )
)

print(statement.render())
print("")

let update = SQLiteStatement(
    .UPDATE(
        .table(Translation.self)
    ),
    .SET(
        .predicate(Translation.Schema.value, .equal("Corrected Translation"))
    ),
    .WHERE(
        .predicate(Translation.Schema.id, .equal(123))
    )
)

print(update.render())
print("")
