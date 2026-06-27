import Foundation

public struct ForeignKey: Sendable {
    public var entity: any Entity.Type
    public var attribute: any Attribute

    public init(_ type: any Entity.Type, attribute: any Attribute) {
        entity = type
        self.attribute = attribute
    }

    public init(_ type: any Entity.Type, _ identifier: String) {
        entity = type
        attribute = AnyAttribute(identifier: identifier)
    }
}
