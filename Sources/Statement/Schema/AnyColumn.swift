import Foundation

public protocol AnyColumn {
    var table: Table.Type { get set }
    var name: String { get set }
    var dataType: String { get set }
    var notNull: Bool { get set }
    var unique: Bool { get set }
    var provideDefault: Bool { get set }
    var primaryKey: Bool { get set }
    var autoIncrement: Bool { get set }
    var foreignKey: AnyColumn? { get set }
    var defaultValue: Encodable? { get }
}

public extension AnyColumn {
    var identifier: String {
        return "\(table.schema.name).\(name)"
    }
}
