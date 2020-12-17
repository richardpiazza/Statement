import Foundation

protocol Column: CodingKey {
    static var tableName: String { get }
}
