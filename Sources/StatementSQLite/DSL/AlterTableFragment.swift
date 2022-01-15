import Statement

struct AlterTable: ClauseFragment, FragmentConvertible {
    let keyword: Keyword = .compound(.alter, .table)
    let separator: String
    let fragments: [Fragment]
    
    init(_ type: Entity.Type, separator: String = " ", @FragmentsBuilder fragments: () -> [Fragment]) {
        self.separator = separator
        self.fragments = [Fragment(value: .raw(type.identifier))] + fragments()
    }
}
