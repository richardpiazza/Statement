import Statement

public extension Segment {
    static func column<E: Entity>(_ type: E.Type, attribute: Attribute) -> Self {
        column(attribute, entity: E.init())
    }
    
    static func column(_ attribute: Attribute, entity: Entity? = nil) -> Self {
        .raw([entity?.tableName, attribute.columnName].compactMap { $0 }.joined(separator: "."))
    }
    
    static func value(_ convertible: DataTypeConvertible) -> Self {
        .raw(convertible.sqliteArgument)
    }
}
