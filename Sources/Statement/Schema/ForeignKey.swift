import Foundation

public struct ForeignKey {
    public var entity: Entity.Type
    public var attribute: Attribute
    
    public init(_ type: Entity.Type, attribute: Attribute) {
        self.entity = type
        self.attribute = attribute
    }
    
    public init(_ type: Entity.Type, _ identifier: String) {
        self.entity = type
        self.attribute = AnyAttribute(identifier: identifier)
    }
}
