import Statement

public extension Segment {
    static func column<E: Entity>(_ type: E.Type, attribute: Attribute) -> Self {
        .attribute(type, attribute: attribute)
    }
    
    static func column(_ attribute: Attribute, entity: Entity? = nil) -> Self {
        .attribute(attribute, entity: entity)
    }
    
    static func value(_ convertible: DataTypeConvertible) -> Self {
        .raw(convertible.sqliteArgument)
    }
}
