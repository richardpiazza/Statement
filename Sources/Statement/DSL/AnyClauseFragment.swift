public struct AnyClauseFragment: ClauseFragment {
    public let keyword: Keyword
    public let separator: String
    public let fragments: [Fragment]
    
    public init(keyword: Keyword, separator: String = " ", @FragmentsBuilder fragments: () -> [Fragment]) {
        self.keyword = keyword
        self.separator = separator
        self.fragments = fragments()
    }
}
