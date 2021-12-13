import Foundation

struct Fragment {
    public enum Value {
        case raw(String)
        case clause(ClauseFragment)
        case comparison(ComparisonFragment)
        case logical(LogicalFragment)
        case conjunctive(ConjunctiveFragment)
        case group(GroupFragment)
        case empty
    }
    
    let id: UUID
    let value: Value
    
    init(id: UUID = UUID(), value: Value) {
        self.id = id
        self.value = value
    }
    
    struct Empty: FragmentConvertible {
        func asFragments() -> [Fragment] {
            []
        }
    }
}

extension Fragment: FragmentRenderable {
    func render() -> String {
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
    func asFragments() -> [Fragment] {
        [self]
    }
}

extension Array: FragmentConvertible where Element == Fragment {
    func asFragments() -> [Fragment] {
        self
    }
}
