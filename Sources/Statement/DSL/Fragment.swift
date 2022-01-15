import Foundation

public struct Fragment {
    public enum Value {
        case raw(String)
        case clause(ClauseFragment)
        case comparison(ComparisonFragment)
        case logical(LogicalFragment)
        case conjunctive(ConjunctiveFragment)
        case group(GroupFragment)
        case empty
    }
    
    public let id: UUID
    public let value: Value
    
    public init(id: UUID = UUID(), value: Value) {
        self.id = id
        self.value = value
    }
    
    public struct Empty: FragmentConvertible {
        public func asFragments() -> [Fragment] {
            []
        }
    }
}

extension Fragment: FragmentRenderable {
    public func render() -> String {
        switch value {
        case .raw(let raw):
            return raw
        case .clause(let clause):
            return clause.render()
        case .comparison(let comparison):
            return comparison.render()
        case .logical(let logical):
            return logical.render()
        case .conjunctive(let conjunctive):
            return conjunctive.render()
        case .group(let group):
            return group.render()
        case .empty:
            return ""
        }
    }
}

extension Fragment: FragmentConvertible {
    public func asFragments() -> [Fragment] {
        [self]
    }
}

extension Array: FragmentConvertible where Element == Fragment {
    public func asFragments() -> [Fragment] {
        self
    }
}
