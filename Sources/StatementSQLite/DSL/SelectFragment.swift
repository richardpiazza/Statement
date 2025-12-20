import Statement

struct Select: ClauseFragment, FragmentConvertible {
    let keyword: Keyword = .select
    let separator: String
    let fragments: [Fragment]
    
    init(separator: String = " ", @FragmentsBuilder fragments: () -> [Fragment]) {
        self.separator = separator
        self.fragments = fragments()
    }
}

struct Column: FragmentConvertible {
    let name: String
    
    init(_ name: String) {
        self.name = name
    }
    
    func asFragments() -> [Fragment] {
        [
            Fragment(value: .raw(name))
        ]
    }
}
