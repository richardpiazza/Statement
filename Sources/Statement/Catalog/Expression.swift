struct Expression: Identifiable, Table {
    
    static let tableName: String = "expression"
    static var columns: [Column] { Schema.allCases }
    
    enum Schema: String, Column, CaseIterable {
        case id
        case name
        case defaultLanguage = "default_language"
        case comment
        case feature
        
        static var tableName: String { Expression.tableName }
    }
    
    /// Unique/Primary Key
    public let id: Int
    /// Key that identifies a collection of translations.
    public var name: String
    /// The default/development language code.
    public var defaultLanguage: LanguageCode
    /// Contextual information that guides translators.
    public var comment: String?
    /// Optional grouping identifier.
    public var feature: String?
    /// Associated translations.
    public var translations: [Translation]
}
