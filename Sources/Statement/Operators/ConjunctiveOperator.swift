public enum ConjunctiveOperator {
    case and
    case or
    
    public func sqlArgument() -> String {
        switch self {
        case .and: return Keyword.and.value
        case .or: return Keyword.or.value
        }
    }
}
