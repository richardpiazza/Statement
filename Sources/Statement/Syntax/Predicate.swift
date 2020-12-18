import Foundation

struct Predicate<Context>: AnyRenderable {
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
