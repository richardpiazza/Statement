import Foundation

struct Predicate<Context> {
    let column: Column
    let comparison: ComparisonOperator
    
    init(_ column: Column, _ comparison: ComparisonOperator) {
        self.column = column
        self.comparison = comparison
    }
    
    func render() -> String {
        var expression: String = ""
        expression += "\(type(of: column).tableName).\(column.stringValue)"
        expression += " \(comparison.expression)"
        return expression
    }
}

extension Predicate: AnyRenderable {
    func render(into renderer: Renderer) {
        renderer.addPredicate(self)
    }
}
