import Foundation

@available(*, deprecated)
protocol Column: CodingKey {
    static var tableName: String { get }
}
