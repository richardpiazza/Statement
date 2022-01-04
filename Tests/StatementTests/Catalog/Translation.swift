import Statement

@available(*, deprecated)
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
    public var language: String = LanguageCode.en.rawValue
    
    /// Region code specifier
    @Column(key: .region)
    public var region: String? = nil
    
    /// The translated string
    @Column(key: .value, notNull: true)
    public var value: String = ""
    
    public var languageCode: LanguageCode {
        get { LanguageCode(rawValue: language) ?? .en }
        set { language = newValue.rawValue }
    }
    
    public var regionCode: RegionCode? {
        get { (region != nil) ? RegionCode(rawValue: region!) : nil }
        set { region = newValue?.rawValue }
    }
}

@available(*, deprecated)
extension Translation: Table {
    public static var schema: Schema = { Translation().schema }()
}

@available(*, deprecated)
public extension Translation {
    static var id: AnyColumn = { schema[.id] }()
    static var expressionID: AnyColumn = { schema[.expressionID] }()
    static var language: AnyColumn = { schema[.language] }()
    static var region: AnyColumn = { schema[.region] }()
    static var value: AnyColumn = { schema[.value] }()
}

@available(*, deprecated)
private extension Schema {
    subscript(codingKey: Translation.CodingKeys) -> AnyColumn {
        guard let column = columns.first(where: { $0.name == codingKey.stringValue }) else {
            preconditionFailure("Invalid column name '\(codingKey.stringValue)'.")
        }
        
        return column
    }
}

@available(*, deprecated)
private extension Column {
    init(wrappedValue: T, key: Translation.CodingKeys, notNull: Bool = false, unique: Bool = false, provideDefault: Bool = false, primaryKey: Bool = false, autoIncrement: Bool = false, foreignKey: AnyColumn? = nil) {
        switch T.self {
        case is Int.Type:
            self.init(wrappedValue: wrappedValue, table: Translation.self, name: key.stringValue, dataType: "INTEGER", notNull: notNull, unique: unique, provideDefault: provideDefault, primaryKey: primaryKey, autoIncrement: autoIncrement, foreignKey: foreignKey)
        default:
            self.init(wrappedValue: wrappedValue, table: Translation.self, name: key.stringValue, dataType: "TEXT", notNull: notNull, unique: unique, provideDefault: provideDefault, primaryKey: primaryKey, autoIncrement: autoIncrement, foreignKey: foreignKey)
        }
    }
}
