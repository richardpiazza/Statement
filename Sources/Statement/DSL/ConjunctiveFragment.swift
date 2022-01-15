public struct ConjunctiveFragment {
    public let conjunctiveOperator: ConjunctiveOperator
    public let fragments: [Fragment]
    
    public init(conjunctiveOperator: ConjunctiveOperator, @FragmentsBuilder fragments: () -> [Fragment]) {
        self.conjunctiveOperator = conjunctiveOperator
        self.fragments = fragments()
    }
    
    public init(conjunctiveOperator: ConjunctiveOperator, fragments: [Fragment]) {
        self.conjunctiveOperator = conjunctiveOperator
        self.fragments = fragments
    }
}

extension ConjunctiveFragment: FragmentRenderable {
    public func render() -> String {
        if fragments.count == 1 {
            return fragments[0].render()
        } else {
            let separator = " \(conjunctiveOperator.rawValue) "
            return fragments.map { $0.render() }.joined(separator: separator)
        }
    }
}
