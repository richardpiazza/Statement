import Foundation

public struct ForeignKey {
    public var entity: Entity
    public var attribute: Attribute
    
    public init(_ tableName: String, _ columnName: String) {
        entity = AnyEntity(tableName: tableName)
        attribute = AnyAttribute(columnName: columnName)
    }
    
    public init(entity: Entity, attribute: Attribute) {
        self.entity = entity
        self.attribute = attribute
    }
}
