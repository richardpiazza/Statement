import Foundation

public struct ForeignKey: Sendable {
    public var entity: Entity.Type
    public var attribute: Attribute

    public init(_ type: Entity.Type, attribute: Attribute) {
        entity = type
        self.attribute = attribute
    }

    public init(_ type: Entity.Type, _ identifier: String) {
        entity = type
        attribute = AnyAttribute(identifier: identifier)
    }
}
