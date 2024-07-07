import Foundation

@propertyWrapper public struct Field<T: DataTypeConvertible & Sendable>: AttributeConvertible, Sendable {
    var identifier: String = ""
    
    public var wrappedValue: T
    private var initialValue: T
    private var unique: Bool
    private var primaryKey: Bool
    private var autoIncrement: Bool
    private var foreignKey: ForeignKey?
    
    public init(wrappedValue: T, _ identifier: String = "", unique: Bool = false, primaryKey: Bool = false, autoIncrement: Bool = false, foreignKey: ForeignKey? = nil) {
        self.wrappedValue = wrappedValue
        self.identifier = identifier
        self.initialValue = wrappedValue
        self.unique = unique
        self.primaryKey = primaryKey
        self.autoIncrement = autoIncrement
        self.foreignKey = foreignKey
    }
    
    public var attribute: Attribute {
        AnyAttribute(
            identifier: identifier,
            dataType: T.dataType,
            unique: unique,
            primaryKey: primaryKey,
            autoIncrement: autoIncrement,
            foreignKey: foreignKey,
            defaultValue: initialValue
        )
    }
}
