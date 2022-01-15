public protocol ClauseFragment: FragmentRenderable {
    var keyword: Keyword { get }
    var separator: String { get }
    var fragments: [Fragment] { get }
}

public extension ClauseFragment {
    func render() -> String {
        [keyword.rawValue, fragments.map { $0.render() }.joined(separator: separator)].joined(separator: " ")
    }
}

public extension ClauseFragment where Self: FragmentConvertible {
    func asFragments() -> [Fragment] {
        [Fragment(value: .clause(self))]
    }
}
