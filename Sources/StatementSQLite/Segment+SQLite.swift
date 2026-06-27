import Statement

public extension Segment {
    static func column(_ type: (some Entity).Type, attribute: any Attribute) -> Self {
        .attribute(type, attribute: attribute)
    }

    static func column(_ attribute: any Attribute, entity: (any Entity)? = nil) -> Self {
        .attribute(attribute, entity: entity)
    }

    static func value(_ convertible: any DataTypeConvertible) -> Self {
        .raw(convertible.sqliteArgument)
    }
}
