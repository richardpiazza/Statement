import Foundation

class LogicalRenderer {
    let `operator`: LogicalOperator
    private var expressions: [String] = []
    
    init(_ `operator`: LogicalOperator) {
        self.operator = `operator`
    }
    
    func render() -> String {
        expressions.joined(separator: " \(`operator`.operator) ")
    }
}

extension LogicalRenderer: Renderer {
    func addRaw(_ text: String) {
        expressions.append(text)
    }
    
    func addSegment<C>(_ segment: Segment<C>) {
        segment.render(into: self)
    }
}
