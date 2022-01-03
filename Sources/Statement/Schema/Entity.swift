import Foundation

public protocol Entity {
    var tableName: String { get }
    var attributes: [Attribute] { get }
    init()
}

public extension Entity {
    var attributes: [Attribute] {
        var _columns: [Attribute] = []
        
        let mirror = Mirror(reflecting: self)
        for child in mirror.children {
            if let column = child.value as? AttributeConvertible {
                _columns.append(column.attribute)
            } else if let column = child.value as? Attribute {
                _columns.append(column)
            }
        }
        
        return _columns
    }
    
    subscript(columnName: String) -> Attribute? {
        attributes.first(where: { $0.columnName == columnName })
    }
    
    subscript(codingKey: CodingKey) -> Attribute? {
        self[codingKey.stringValue]
    }
    
    static subscript(columnName: String) -> Attribute? {
        Self.init()[columnName]
    }
    
    static subscript(codingKey: CodingKey) -> Attribute? {
        self[codingKey.stringValue]
    }
}
