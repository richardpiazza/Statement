import Foundation

public protocol AnyColumn {
    var table: SchemaTable.Type { get set }
    var name: String { get set }
    var notNull: Bool { get set }
    var unique: Bool { get set }
    var provideDefault: Bool { get set }
    var primaryKey: Bool { get set }
    var foreignKey: AnyColumn? { get set }
}

public extension AnyColumn {
    var identifier: String {
        return "\(table.schema.name).\(name)"
    }
}
