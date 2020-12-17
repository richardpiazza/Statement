struct Translation: Identifiable, Table {
    
    static let tableName: String = "translation"
    static var columns: [Column] { Schema.allCases }
    
    enum Schema: String, Column, CaseIterable {
        case id
        case expressionID = "expresion_id"
        case language = "language_code"
        case region = "region_code"
        case value
        
        static var tableName: String { Translation.tableName }
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
