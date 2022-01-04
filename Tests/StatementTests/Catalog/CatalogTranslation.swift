import Statement

struct CatalogTranslation: Entity, Identifiable {
    let tableName: String = "translation"
    @Field("id", unique: true, primaryKey: true, autoIncrement: true) var id: Int = 0
    @Field("expression_id", foreignKey: .init("expression", "id")) var expressionID: CatalogExpression.ID = 0
    @Field("language_code") var language: String = LanguageCode.en.rawValue
    @Field("region_code") var region: String? = nil
    @Field("value") var value: String = ""
    
    var languageCode: LanguageCode {
        get { LanguageCode(rawValue: language) ?? .en }
        set { language = newValue.rawValue }
    }
    
    var regionCode: RegionCode? {
        get { (region != nil) ? RegionCode(rawValue: region!) : nil }
        set { region = newValue?.rawValue }
    }
}
