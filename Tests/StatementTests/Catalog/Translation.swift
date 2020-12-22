import Statement

public struct Translation: Identifiable {
    
    internal var schema: Schema {
        return Schema(
            name: "translation",
            columns: [_id, _expressionID, _language, _region, _value]
        )
    }
    
    internal enum CodingKeys: String, CodingKey {
        case id
        case expressionID = "expression_id"
        case language = "language_code"
        case region = "region_code"
        case value
    }
    
    /// Unique/Primary Key
    @Column(key: .id, notNull: true, unique: true, primaryKey: true, autoIncrement: true)
    public var id: Int = 0
    
    /// Expression (Foreign Key)
    @Column(key: .expressionID, notNull: true, foreignKey: Expression.id)
    public var expressionID: Expression.ID = 0
    
    /// Language of the translation
    @Column(key: .language, notNull: true)
    public var language: LanguageCode = .en
    
    /// Region code specifier
    @Column(key: .region)
    public var region: RegionCode? = nil
    
    /// The translated string
    @Column(key: .value, notNull: true)
    public var value: String = ""
}

extension Translation: Table {
    public static var schema: Schema = { Translation().schema }()
}

public extension Translation {
    static var id: AnyColumn = { schema[.id] }()
    static var expressionID: AnyColumn = { schema[.expressionID] }()
    static var language: AnyColumn = { schema[.language] }()
    static var region: AnyColumn = { schema[.region] }()
    static var value: AnyColumn = { schema[.value] }()
}

private extension Schema {
    subscript(codingKey: Translation.CodingKeys) -> AnyColumn {
        guard let column = columns.first(where: { $0.name == codingKey.stringValue }) else {
            preconditionFailure("Invalid column name '\(codingKey.stringValue)'.")
        }
        
        return column
    }
}

private extension Column {
    init(wrappedValue: T, key: Translation.CodingKeys, notNull: Bool = false, unique: Bool = false, provideDefault: Bool = false, primaryKey: Bool = false, autoIncrement: Bool = false, foreignKey: AnyColumn? = nil) {
        self.init(wrappedValue: wrappedValue, table: Translation.self, name: key.stringValue, notNull: notNull, unique: unique, provideDefault: provideDefault, primaryKey: primaryKey, autoIncrement: autoIncrement, foreignKey: foreignKey)
    }
}
