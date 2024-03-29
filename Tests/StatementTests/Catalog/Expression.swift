import Statement

struct Expression: Entity, Identifiable {
    static let identifier: String = "expression"
    let tableName: String = "expression"
    @Field("id", unique: true, primaryKey: true, autoIncrement: true) var id: Int = 0
    @Field("name") var name: String = ""
    @Field("default_language") var defaultLanguage: String = LanguageCode.en.rawValue
    @Field("comment") var comment: String? = nil
    @Field("feature") var feature: String? = nil
    var translations: [Translation] = []
    
    var languageCode: LanguageCode {
        get { LanguageCode(rawValue: defaultLanguage) ?? .en }
        set { defaultLanguage = newValue.rawValue }
    }
}
