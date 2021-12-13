import Foundation

typealias Statement = FragmentGroup

struct FragmentGroup {
    let id: UUID
    let fragments: [Fragment]
    
    init(id: UUID = UUID(), @FragmentsBuilder fragments: () -> [Fragment]) {
        self.id = id
        self.fragments = fragments()
    }
}

extension FragmentGroup: FragmentRenderable {
    func render() -> String {
        fragments.map { $0.render() }.joined(separator: " ")
    }
}

extension FragmentGroup: FragmentConvertible {
    func asFragments() -> [Fragment] {
        [Fragment(value: .group(GroupFragment(fragments: fragments)))]
    }
}
