import Foundation

@propertyWrapper
public struct SchemaColumn<T>: AnyColumn {
    public var wrappedValue: T
    public var defaultValue: T
    public var table: SchemaTable.Type
    public var name: String
    public var notNull: Bool
    public var unique: Bool
    public var provideDefault: Bool
    public var primaryKey: Bool
    public var foreignKey: AnyColumn?
    
    public init(
        wrappedValue: T,
        table: SchemaTable.Type,
        name: String,
        notNull: Bool = false,
        unique: Bool = false,
        provideDefault: Bool = false,
        primaryKey: Bool = false,
        foreignKey: AnyColumn? = nil
    ) {
        self.wrappedValue = wrappedValue
        self.defaultValue = wrappedValue
        self.table = table
        self.name = name
        self.notNull = notNull
        self.unique = unique
        self.provideDefault = provideDefault
        self.primaryKey = primaryKey
        self.foreignKey = foreignKey
    }
    
    public var description: String {
        var descriptors: [String] = []
        descriptors.append("NAME: \(name)")
        if notNull {
            descriptors.append("NOT NULL")
        }
        if unique {
            descriptors.append("UNIQUE")
        }
        if provideDefault {
            descriptors.append("DEFAULT \(defaultValue)")
        }
        
        if let value = wrappedValue as? String, value.isEmpty {
            descriptors.append("VALUE: {empty}")
        } else {
            descriptors.append("VALUE: \(wrappedValue)")
        }
        
        return descriptors.joined(separator: ", ")
    }
}
