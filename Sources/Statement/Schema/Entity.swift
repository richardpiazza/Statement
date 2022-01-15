import Foundation

public protocol Entity {
    static var identifier: String { get }
    var attributes: [Attribute] { get }
}

public extension Entity {
    var attributes: [Attribute] {
        var _attributes: [Attribute] = []
        
        let mirror = Mirror(reflecting: self)
        for child in mirror.children {
            if let column = child.value as? AttributeConvertible {
                _attributes.append(column.attribute)
            } else if let column = child.value as? Attribute {
                _attributes.append(column)
            }
        }
        
        return _attributes
    }
    
    subscript(attributeIdentifier: String) -> Attribute? {
        attributes.first(where: { $0.identifier == attributeIdentifier })
    }
}
