import Foundation

@available(*, deprecated)
public struct Schema {
    public var name: String
    public var columns: [AnyColumn]
    
    public init(name: String, columns: [AnyColumn]) {
        self.name = name
        self.columns = columns
    }
}

@available(*, deprecated)
public extension Schema {
    subscript(columnName: String) -> AnyColumn? {
        columns.first { $0.name == columnName }
    }
    
    subscript(codingKey: CodingKey) -> AnyColumn? {
        self[codingKey.stringValue]
    }
}

@available(*, deprecated)
extension Schema: CustomStringConvertible {
    public var description: String {
        """
        Table: \(name)
        Columns: [
            \(columns.map { String(describing: $0) }.joined(separator: "\n\t"))
        ]
        """
    }
}
