struct LogicalFragment {
    let logicalOperator: LogicalOperator
    let fragments: [Fragment]
    
    init(logicalOperator: LogicalOperator, @FragmentsBuilder fragments: () -> [Fragment]) {
        self.logicalOperator = logicalOperator
        self.fragments = fragments()
    }
    
    init(logicalOperator: LogicalOperator, fragments: [Fragment]) {
        self.logicalOperator = logicalOperator
        self.fragments = fragments
    }
}

extension LogicalFragment: FragmentRenderable {
    func render() -> String {
        if fragments.count == 1 {
            return [fragments.map { $0.render() }.joined(), logicalOperator.rawValue].joined(separator: " ")
        } else {
            let separator = " \(logicalOperator.rawValue) "
            return fragments.map { $0.render() }.joined(separator: separator)
        }
    }
}
