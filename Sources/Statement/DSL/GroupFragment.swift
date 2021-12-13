struct GroupFragment {
    let prefix: String
    let suffix: String
    let separator: String
    let fragments: [Fragment]
    
    init(prefix: String = "(", suffix: String = ")", separator: String = ", ", @FragmentsBuilder fragments: () -> [Fragment]) {
        self.prefix = prefix
        self.suffix = suffix
        self.separator = separator
        self.fragments = fragments()
    }
    
    init(prefix: String = "(", suffix: String = ")", separator: String = ", ", fragments: [Fragment]) {
        self.prefix = prefix
        self.suffix = suffix
        self.separator = separator
        self.fragments = fragments
    }
}

extension GroupFragment: FragmentRenderable {
    func render() -> String {
        [prefix, fragments.map { $0.render() }.joined(separator: separator), suffix].joined(separator: " ")
    }
}
