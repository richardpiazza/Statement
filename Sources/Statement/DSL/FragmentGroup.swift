import Foundation

public typealias Statement = FragmentGroup

public struct FragmentGroup {
    public let id: UUID
    public let fragments: [Fragment]
    
    public init(id: UUID = UUID(), @FragmentsBuilder fragments: () -> [Fragment]) {
        self.id = id
        self.fragments = fragments()
    }
}

extension FragmentGroup: FragmentRenderable {
    public func render() -> String {
        fragments.map { $0.render() }.joined(separator: " ")
    }
}

extension FragmentGroup: FragmentConvertible {
    public func asFragments() -> [Fragment] {
        [Fragment(value: .group(GroupFragment(fragments: fragments)))]
    }
}
