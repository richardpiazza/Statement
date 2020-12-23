import Foundation

@propertyWrapper
public struct Column<T: Encodable>: AnyColumn {
    public var wrappedValue: T
    public var table: Table.Type
    public var name: String
    public var dataType: String
    public var notNull: Bool
    public var unique: Bool
    public var provideDefault: Bool
    public var primaryKey: Bool
    public var autoIncrement: Bool
    public var foreignKey: AnyColumn?
    
    private var initialValue: T
    
    public init(
        wrappedValue: T,
        table: Table.Type,
        name: String,
        dataType: String,
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
        self.dataType = dataType
        self.notNull = notNull
        self.unique = unique
        self.provideDefault = provideDefault
        self.primaryKey = primaryKey
        self.autoIncrement = autoIncrement
        self.foreignKey = foreignKey
    }
    
    public var defaultValue: Encodable? {
        guard provideDefault else {
            return nil
        }
        
        switch self {
        case let cast as Column<Optional<String>>:
            return (cast.initialValue != nil) ? cast.initialValue : NSNull()
        case let cast as Column<Optional<Int>>:
            return (cast.initialValue != nil) ? cast.initialValue : NSNull()
        case let cast as Column<Optional<Double>>:
            return (cast.initialValue != nil) ? cast.initialValue : NSNull()
        default:
            break
        }
        
        return nil
    }
    
    public var description: String {
        var descriptors: [String] = []
        descriptors.append(name)
        descriptors.append(dataType)
        if notNull {
            descriptors.append("NOT NULL")
        }
        if unique {
            descriptors.append("UNIQUE")
        }
        if let value = defaultValue {
            descriptors.append("DEFAULT \(value.sqlString)")
        }
        if primaryKey {
            descriptors.append("PRIMARY KEY")
        }
        if autoIncrement {
            descriptors.append("AUTOINCREMENT")
        }
        if let value = foreignKey {
            descriptors.append("REFERENCES \(value)")
        }
        if let value = wrappedValue as? String, value.isEmpty {
            descriptors.append("VALUE: {empty}")
        } else {
            descriptors.append("VALUE: \(wrappedValue.sqlString)")
        }
        
        return descriptors.joined(separator: " ")
    }
}
