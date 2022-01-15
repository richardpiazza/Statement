public struct ComparisonFragment {
    public let comparisonOperator: ComparisonOperator
    public let fragments: [Fragment]
    
    public init(comparisonOperator: ComparisonOperator, @FragmentsBuilder fragments: () -> [Fragment]) {
        self.comparisonOperator = comparisonOperator
        self.fragments = fragments()
    }
    
    public init(comparisonOperator: ComparisonOperator, fragments: [Fragment]) {
        self.comparisonOperator = comparisonOperator
        self.fragments = fragments
    }
}

extension ComparisonFragment: FragmentRenderable {
    public func render() -> String {
        guard fragments.count > 1 else {
            return ""
        }
        
        let lhs = fragments[0]
        let rhs = fragments[1]
        
        return [lhs.render(), comparisonOperator.rawValue, rhs.render()].joined(separator: " ")
    }
}
