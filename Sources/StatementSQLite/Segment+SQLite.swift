import Statement

public extension Segment {
    static func value(_ convertible: DataTypeConvertible) -> Self {
        .raw(convertible.sqliteArgument)
    }
}
