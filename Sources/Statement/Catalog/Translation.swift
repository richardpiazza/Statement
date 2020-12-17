struct Translation: Identifiable, Table {
    
    static let schema: TableSchema = .init(
        name: "translation",
        columns: Schema.allCases.map { $0.rawValue }
    )
    
    enum Schema: String, Column, CaseIterable {
        case id
        case expressionID = "expresion_id"
        case language = "language_code"
        case region = "region_code"
        case value
        
        static var tableName: String { Translation.schema.name }
    }
    
    /// Unique/Primary Key
    public let id: Int
    /// Expression (Foreign Key)
    public let expressionID: Expression.ID
    /// Language of the translation
    public var language: LanguageCode
    /// Region code specifier
    public var region: RegionCode?
    /// The translated string
    public var value: String
}
