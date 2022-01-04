import Foundation

public struct AnyEntity: Entity {
    public var tableName: String = ""
    public var attributes: [Attribute] = []
    
    public init() {
    }
    
    public init(tableName: String = "", attributes: [Attribute] = []) {
        self.tableName = tableName
        self.attributes = attributes
    }
}

extension AnyEntity: CustomStringConvertible {
    public var description: String {
        """
        Table: \(tableName)
        Columns: [
            \(attributes.map { String(describing: $0) }.joined(separator: "\n\t"))
        ]
        """
    }
}
