import Foundation

@propertyWrapper
public struct Column<T: Encodable>: AnyColumn {
    public private(set) var wrappedValue: T
    private var initialValue: T
    public var table: Table.Type
    public var name: String
    public var notNull: Bool
    public var unique: Bool
    public var provideDefault: Bool
    public var primaryKey: Bool
    public var autoIncrement: Bool
    public var foreignKey: AnyColumn?
    
    public init(
        wrappedValue: T,
        table: Table.Type,
        name: String,
        notNull: Bool = false,
        unique: Bool = false,
        provideDefault: Bool = false,
        primaryKey: Bool = false,
        autoIncrement: Bool = false,
        foreignKey: AnyColumn? = nil
    ) {
        self.wrappedValue = wrappedValue
        self.initialValue = wrappedValue
        self.table = table
        self.name = name
        self.notNull = notNull
        self.unique = unique
        self.provideDefault = provideDefault
        self.primaryKey = primaryKey
        self.autoIncrement = autoIncrement
        self.foreignKey = foreignKey
    }
    
    public var defaultValue: Encodable? {
        return nil
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
            descriptors.append("DEFAULT \(initialValue)")
        }
        if primaryKey {
            descriptors.append("PRIMARY KEY")
        }
        if autoIncrement {
            descriptors.append("AUTOINCREMENT")
        }
        
        if let value = wrappedValue as? String, value.isEmpty {
            descriptors.append("VALUE: {empty}")
        } else {
            descriptors.append("VALUE: \(wrappedValue)")
        }
        
        return descriptors.joined(separator: ", ")
    }
}
