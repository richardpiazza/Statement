import Foundation

public struct AnyAttribute: Attribute {
    public var columnName: String = ""
    public var dataType: DataType = .string
    public var unique: Bool = false
    public var primaryKey: Bool = false
    public var autoIncrement: Bool = false
    public var foreignKey: ForeignKey?
    public var defaultValue: DataTypeConvertible?
}
