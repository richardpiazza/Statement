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
        .AND(
            Element.expression(Translation.Schema.language, .equal("en")),
            Element.expression(Translation.Schema.region, .equal("US"))
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
        .expression(Translation.Schema.value, .equal("Corrected Translation"))
    ),
    .WHERE(
        .predicate(Predicate(Translation.Schema.id, .equal(123)))
//        Element.expression(Translation.Schema.id, .equal(123))
    )
)

struct Predicate<Context>: AnyElement {
    let column: Column
    let comparison: ComparisonOperator
    
    init(_ column: Column, _ comparison: ComparisonOperator) {
        self.column = column
        self.comparison = comparison
    }
    
    func render(into renderer: Renderer) {
        var expression: String = ""
        expression += "\(type(of: column).tableName).\(column.stringValue)"
        expression += " \(comparison.expression)"
        renderer.addRaw(expression)
    }
}

print(update.render())
print("")
