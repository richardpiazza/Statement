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
