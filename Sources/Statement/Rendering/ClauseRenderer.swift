import Foundation

class ClauseRenderer: Renderer {
    let keyword: Keyword
    let separator: String
    var components: [String] = []
    
    init(_ keyword: Keyword, separator: String) {
        self.keyword = keyword
        self.separator = separator
    }
    
    func render() -> String {
        keyword.value + " " + components.joined(separator: separator)
    }
}
