import Statement

@available(*, deprecated)
public struct Expression: Identifiable {
    
    internal var schema: Schema {
        return Schema(
            name: "expression",
            columns: [_id, _name, _defaultLanguage, _comment, _feature]
        )
    }
    
    internal enum CodingKeys: String, CodingKey {
        case id
        case name
        case defaultLanguage = "default_language"
        case comment
        case feature
        case translations
    }
    
    /// Unique/Primary Key
    @Column(key: .id, notNull: true, unique: true, primaryKey: true, autoIncrement: true)
    public var id: Int = 0
    
    /// Key that identifies a collection of translations.
    @Column(key: .name, notNull: true)
    public var name: String = ""
    
    /// The default/development language code.
    @Column(key: .defaultLanguage, notNull: true)
    public var defaultLanguage: String = LanguageCode.en.rawValue
    
    /// Contextual information that guides translators.
    @Column(key: .comment)
    public var comment: String? = nil
    
    /// Optional grouping identifier.
    @Column(key: .feature)
    public var feature: String? = nil
    
    /// Associated translations.
    public var translations: [Translation] = []
    
    public var languageCode: LanguageCode {
        get { LanguageCode(rawValue: defaultLanguage) ?? .en }
        set { defaultLanguage = newValue.rawValue }
    }
}

@available(*, deprecated)
extension Expression: Table {
    public static var schema: Schema = { Expression().schema }()
}

@available(*, deprecated)
public extension Expression {
    static var id: AnyColumn = { schema[.id] }()
    static var name: AnyColumn = { schema[.name] }()
    static var defaultLanguage: AnyColumn = { schema[.defaultLanguage] }()
    static var comment: AnyColumn = { schema[.comment] }()
    static var feature: AnyColumn = { schema[.feature] }()
}

@available(*, deprecated)
private extension Schema {
    subscript(codingKey: Expression.CodingKeys) -> AnyColumn {
        guard let column = columns.first(where: { $0.name == codingKey.stringValue }) else {
            preconditionFailure("Invalid column name '\(codingKey.stringValue)'.")
        }
        
        return column
    }
}

@available(*, deprecated)
private extension Column {
    init(wrappedValue: T, key: Expression.CodingKeys, notNull: Bool = false, unique: Bool = false, provideDefault: Bool = false, primaryKey: Bool = false, autoIncrement: Bool = false, foreignKey: AnyColumn? = nil) {
        switch T.self {
        case is Int.Type:
            self.init(wrappedValue: wrappedValue, table: Expression.self, name: key.stringValue, dataType: "INTEGER", notNull: notNull, unique: unique, provideDefault: provideDefault, primaryKey: primaryKey, autoIncrement: autoIncrement, foreignKey: foreignKey)
        default:
            self.init(wrappedValue: wrappedValue, table: Expression.self, name: key.stringValue, dataType: "TEXT", notNull: notNull, unique: unique, provideDefault: provideDefault, primaryKey: primaryKey, autoIncrement: autoIncrement, foreignKey: foreignKey)
        }
    }
}
