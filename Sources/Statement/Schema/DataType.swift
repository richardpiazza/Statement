import Foundation

public indirect enum DataType {
    case bool
    case data
    case date
    case double
    case int
    case string
    case url
    case uuid
    case optional(DataType)
    case null
}
