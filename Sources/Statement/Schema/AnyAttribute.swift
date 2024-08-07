import Foundation

public struct AnyAttribute: Attribute {
    public var identifier: String = ""
    public var dataType: DataType = .null
    public var unique: Bool = false
    public var primaryKey: Bool = false
    public var autoIncrement: Bool = false
    public var foreignKey: ForeignKey?
    public var defaultValue: (DataTypeConvertible & Sendable)?
    
    public init(
        identifier: String = "",
        dataType: DataType = .null,
        unique: Bool = false,
        primaryKey: Bool = false,
        autoIncrement: Bool = false,
        foreignKey: ForeignKey? = nil,
        defaultValue: (DataTypeConvertible & Sendable)? = nil
    ) {
        self.identifier = identifier
        self.dataType = dataType
        self.unique = unique
        self.primaryKey = primaryKey
        self.autoIncrement = autoIncrement
        self.foreignKey = foreignKey
        self.defaultValue = defaultValue
    }
}
