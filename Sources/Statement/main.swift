let statement = SQLiteStatement(
    .SELECT(
        .column(Expression.Schema.id),
        .column(Expression.Schema.name),
        .column(Expression.Schema.defaultLanguage),
        .column(Expression.Schema.comment),
        .column(Expression.Schema.feature)
    ),
    .FROM(
        .table(Expression.tableName)
    ),
    .JOIN(
        .table(Translation.tableName),
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
