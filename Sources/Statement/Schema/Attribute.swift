import Foundation

public protocol Attribute {
    var identifier: String { get }
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
        descriptors.append(identifier)
        descriptors.append("TYPE \(String(describing: dataType))")
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
            descriptors.append("REFERENCES \(value.entity.identifier).\(value.attribute.identifier)")
        }
        return descriptors
    }
}
