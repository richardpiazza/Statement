import Foundation

struct TableSchema {
    var name: String
    var columns: [String]
}

protocol Table {
    static var schema: TableSchema { get }
}
