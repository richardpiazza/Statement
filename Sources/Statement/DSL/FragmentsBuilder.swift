@resultBuilder public enum FragmentsBuilder {
    public static func buildBlock() -> [Fragment] {
        []
    }
    
    public static func buildBlock(_ components: FragmentConvertible...) -> [Fragment] {
        components.flatMap { $0.asFragments() }
    }
    
    public static func buildOptional(_ component: FragmentConvertible?) -> FragmentConvertible {
        component ?? []
    }
    
    public static func buildEither(first component: FragmentConvertible) -> FragmentConvertible {
        component
    }
    
    public static func buildEither(second component: FragmentConvertible) -> FragmentConvertible {
        component
    }
}
