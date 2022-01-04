import Foundation

@propertyWrapper public struct Field<T: DataTypeConvertible>: AttributeConvertible {
    var name: String = ""
    
    public var wrappedValue: T
    private var initialValue: T
    private var unique: Bool
    private var primaryKey: Bool
    private var autoIncrement: Bool
    private var foreignKey: ForeignKey?
    
    public init(wrappedValue: T, _ name: String = "", unique: Bool = false, primaryKey: Bool = false, autoIncrement: Bool = false, foreignKey: ForeignKey? = nil) {
        self.wrappedValue = wrappedValue
        self.name = name
        self.initialValue = wrappedValue
        self.unique = unique
        self.primaryKey = primaryKey
        self.autoIncrement = autoIncrement
        self.foreignKey = foreignKey
    }
    
    public var attribute: Attribute {
        AnyAttribute(
            columnName: name,
            dataType: T.dataType,
            unique: unique,
            primaryKey: primaryKey,
            autoIncrement: autoIncrement,
            foreignKey: foreignKey,
            defaultValue: initialValue
        )
    }
}
