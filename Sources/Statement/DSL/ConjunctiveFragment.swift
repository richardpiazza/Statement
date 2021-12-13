struct ConjunctiveFragment {
    let conjunctiveOperator: ConjunctiveOperator
    let fragments: [Fragment]
    
    init(conjunctiveOperator: ConjunctiveOperator, @FragmentsBuilder fragments: () -> [Fragment]) {
        self.conjunctiveOperator = conjunctiveOperator
        self.fragments = fragments()
    }
    
    init(conjunctiveOperator: ConjunctiveOperator, fragments: [Fragment]) {
        self.conjunctiveOperator = conjunctiveOperator
        self.fragments = fragments
    }
}

extension ConjunctiveFragment: FragmentRenderable {
    func render() -> String {
        if fragments.count == 1 {
            return fragments[0].render()
        } else {
            let separator = " \(conjunctiveOperator.rawValue) "
            return fragments.map { $0.render() }.joined(separator: separator)
        }
    }
}
