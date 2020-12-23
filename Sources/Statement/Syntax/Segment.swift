import Foundation

public enum Segment<Context> {
    case raw(String)
    case clause(Clause<Context>)
    case comparisonPredicate(ComparisonPredicate<Context>)
    case logicalPredicate(LogicalPredicate<Context>)
    case group(Group<Context>)
    case empty
}

extension Segment: AnyRenderable {
    public func render(into renderer: Renderer) {
        switch self {
        case .raw(let identifier):
            renderer.addRaw(identifier)
        case .clause(let clause):
            renderer.addClause(clause)
        case .comparisonPredicate(let predicate):
            renderer.addComparisonPredicate(predicate)
        case .logicalPredicate(let predicate):
            renderer.addLogicalPredicate(predicate)
        case .group(let group):
            renderer.addGroup(group)
        case .empty:
            break
        }
    }
}

public extension Segment {
    static func keyword(_ keyword: Keyword) -> Self {
        .raw(keyword.value)
    }
    
    static func table<T: Table>(_ type: T.Type) -> Self {
        return .raw(T.schema.name)
    }
    
    static func column(_ column: AnyColumn?) -> Self {
        guard let column = column else {
            return .empty
        }
        
        return .raw(column.identifier)
    }
    
    static func comparison(_ column: AnyColumn, _ op: ComparisonOperator) -> Self {
        return .comparisonPredicate(ComparisonPredicate<Context>(column: column, comparison: op))
    }
    
    static func limit(_ limit: Int) -> Self {
        .raw("\(limit)")
    }
    
    static func value(_ encodable: Encodable) -> Self {
        .raw(encodable.sqlString)
    }
}

public extension Segment {
    static func `if`(_ condition: Bool, _ segment: Segment, else fallback: Segment? = nil) -> Segment {
        guard condition else {
            return fallback ?? .empty
        }
        
        return segment
    }
    
    static func unwrap<T>(_ optional: T?, transform: (T) throws -> Segment, else fallback: Segment = .empty) rethrows -> Segment {
        try optional.map(transform) ?? fallback
    }
    
    static func forEach<S: Sequence>(_ sequence: S, _ transform: (S.Element) throws -> Segment) rethrows -> Segment {
        try .group(Group(segments: sequence.map(transform)))
    }
}
