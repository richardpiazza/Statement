public struct GroupFragment {
    public let prefix: String
    public let suffix: String
    public let separator: String
    public let fragments: [Fragment]
    
    public init(prefix: String = "(", suffix: String = ")", separator: String = ", ", @FragmentsBuilder fragments: () -> [Fragment]) {
        self.prefix = prefix
        self.suffix = suffix
        self.separator = separator
        self.fragments = fragments()
    }
    
    public init(prefix: String = "(", suffix: String = ")", separator: String = ", ", fragments: [Fragment]) {
        self.prefix = prefix
        self.suffix = suffix
        self.separator = separator
        self.fragments = fragments
    }
}

extension GroupFragment: FragmentRenderable {
    public func render() -> String {
        [prefix, fragments.map { $0.render() }.joined(separator: separator), suffix].joined(separator: " ")
    }
}
