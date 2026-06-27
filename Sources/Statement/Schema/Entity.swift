import Foundation

public protocol Entity: Sendable {
    static var identifier: String { get }
    var attributes: [any Attribute] { get }
}

public extension Entity {
    var attributes: [any Attribute] {
        var _attributes: [any Attribute] = []

        let mirror = Mirror(reflecting: self)
        for child in mirror.children {
            if let column = child.value as? (any AttributeConvertible) {
                _attributes.append(column.attribute)
            } else if let column = child.value as? (any Attribute) {
                _attributes.append(column)
            }
        }

        return _attributes
    }

    subscript(attributeIdentifier: String) -> (any Attribute)? {
        attributes.first(where: { $0.identifier == attributeIdentifier })
    }
}
