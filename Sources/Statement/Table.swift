import Foundation

struct TableSchema {
    var name: String
    var columns: [String]
}

protocol Table {
//    associatedtype Schema: Column
    static var schema: TableSchema { get }
}
