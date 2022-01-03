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

extension UUID: DataTypeConvertible {
    public static var dataType: DataType { .uuid }
}

extension Optional: DataTypeConvertible {
    public static var dataType: DataType {
        if self == Optional<Bool>.self {
            return .optional(.bool)
        } else if self == Optional<Data>.self {
                return .optional(.data)
        } else if self == Optional<Date>.self {
            return .optional(.date)
        } else if self == Optional<Double>.self {
            return .optional(.double)
        } else if self == Optional<Int>.self {
            return .optional(.int)
        } else if self == Optional<String>.self {
            return .optional(.string)
        } else if self == Optional<UUID>.self {
            return .optional(.uuid)
        }
        
        preconditionFailure("Invalid DataType \(type(of: self))")
    }
}
