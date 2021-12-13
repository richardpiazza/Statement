@resultBuilder enum FragmentsBuilder {
    static func buildBlock() -> [Fragment] {
        []
    }
    
    static func buildBlock(_ components: FragmentConvertible...) -> [Fragment] {
        components.flatMap { $0.asFragments() }
    }
    
    static func buildOptional(_ component: FragmentConvertible?) -> FragmentConvertible {
        component ?? []
    }
    
    static func buildEither(first component: FragmentConvertible) -> FragmentConvertible {
        component
    }
    
    static func buildEither(second component: FragmentConvertible) -> FragmentConvertible {
        component
    }
}
