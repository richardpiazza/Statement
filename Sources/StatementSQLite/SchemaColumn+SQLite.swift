import Statement

extension Field: CustomStringConvertible {
    public var description: String {
        let column = self.attribute
        var descriptors = column.descriptors
        descriptors.insert(column.dataType.sqliteDataType, at: 1)
        if let value = column.defaultValue {
            if let index = descriptors.firstIndex(where: { $0.hasPrefix("DEFAULT") }) {
                descriptors[index] = "DEFAULT \(value.sqliteArgument)"
            } else {
                descriptors.append("DEFAULT \(value.sqliteArgument)")
            }
        }
        descriptors.append("VALUE: \(wrappedValue.sqliteArgument)")
        return descriptors.joined(separator: " ")
    }
}
