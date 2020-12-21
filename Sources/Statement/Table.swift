import Foundation

struct TableSchema {
    var name: String
    var columns: [String]
}

@available(*, deprecated)
protocol Table {
    static var schema: TableSchema { get }
}
