import Foundation

class ClauseRenderer {
    let keyword: Keyword
    let separator: String
    private var components: [String] = []
    
    init(_ keyword: Keyword, separator: String) {
        self.keyword = keyword
        self.separator = separator
    }
    
    func render() -> String {
        keyword.value + " " + components.joined(separator: separator)
    }
}

extension ClauseRenderer: Renderer {
    func addRaw(_ text: String) {
        components.append(text)
    }
    
    func addSegment<C>(_ segment: Segment<C>) {
        segment.render(into: self)
    }
}
