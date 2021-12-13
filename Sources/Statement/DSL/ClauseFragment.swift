protocol ClauseFragment: FragmentRenderable {
    var keyword: Keyword { get }
    var separator: String { get }
    var fragments: [Fragment] { get }
}

extension ClauseFragment {
    func render() -> String {
        [keyword.rawValue, fragments.map { $0.render() }.joined(separator: separator)].joined(separator: " ")
    }
}

struct AnyClauseFragment: ClauseFragment {
    let keyword: Keyword
    let separator: String
    let fragments: [Fragment]
    
    init(keyword: Keyword, separator: String = " ", @FragmentsBuilder fragments: () -> [Fragment]) {
        self.keyword = keyword
        self.separator = separator
        self.fragments = fragments()
    }
}

struct Select: ClauseFragment, FragmentConvertible {
    let keyword: Keyword = .select
    let separator: String
    let fragments: [Fragment]
    
    init(separator: String = " ", @FragmentsBuilder fragments: () -> [Fragment]) {
        self.separator = separator
        self.fragments = fragments()
    }
    
    func asFragments() -> [Fragment] {
        [Fragment(value: .clause(self))]
    }
}
