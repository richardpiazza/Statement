import Foundation

public protocol Attribute {
    var columnName: String { get }
    var dataType: DataType { get }
    var unique: Bool { get }
    var primaryKey: Bool { get }
    var autoIncrement: Bool { get }
    var foreignKey: ForeignKey? { get }
    var defaultValue: DataTypeConvertible? { get }
}

public extension Attribute {
    var isOptional: Bool {
        if case .optional = dataType {
            return true
        } else {
            return false
        }
    }
    
    var notNull: Bool { !isOptional }
    
    var descriptors: [String] {
        var descriptors: [String] = []
        descriptors.append(columnName)
        if notNull {
            descriptors.append("NOT NULL")
        }
        if unique {
            descriptors.append("UNIQUE")
        }
        if let value = defaultValue {
            descriptors.append("DEFAULT \(value)")
        }
        if primaryKey {
            descriptors.append("PRIMARY KEY")
        }
        if autoIncrement {
            descriptors.append("AUTOINCREMENT")
        }
        if let value = foreignKey {
            descriptors.append("REFERENCES \(value.entity.tableName).\(value.attribute.columnName)")
        }
        return descriptors
    }
}
