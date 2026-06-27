import Foundation

public protocol DataTypeConvertible {
    static var dataType: DataType { get }
}

extension Bool: DataTypeConvertible {
    public static var dataType: DataType { .bool }
}

extension Data: DataTypeConvertible {
    public static var dataType: DataType { .data }
}

extension Date: DataTypeConvertible {
    public static var dataType: DataType { .date }
}

extension Double: DataTypeConvertible {
    public static var dataType: DataType { .double }
}

extension Int: DataTypeConvertible {
    public static var dataType: DataType { .int }
}

extension String: DataTypeConvertible {
    public static var dataType: DataType { .string }
}

extension URL: DataTypeConvertible {
    public static var dataType: DataType { .url }
}

extension UUID: DataTypeConvertible {
    public static var dataType: DataType { .uuid }
}

extension Optional: DataTypeConvertible {
    public static var dataType: DataType {
        if self == Bool?.self {
            return .optional(.bool)
        } else if self == Data?.self {
            return .optional(.data)
        } else if self == Date?.self {
            return .optional(.date)
        } else if self == Double?.self {
            return .optional(.double)
        } else if self == Int?.self {
            return .optional(.int)
        } else if self == String?.self {
            return .optional(.string)
        } else if self == URL?.self {
            return .optional(.url)
        } else if self == UUID?.self {
            return .optional(.uuid)
        } else {
            return .null
        }
    }
}
