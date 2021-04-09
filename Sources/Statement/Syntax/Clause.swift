import Foundation

public struct Clause<Context> {
    
    public var keyword: Keyword
    public var segments: [AnyRenderable]
    public var separator: String
    
    public init(keyword: Keyword, segments: [AnyRenderable], separator: String = " ") {
        self.keyword = keyword
        self.segments = segments
        self.separator = separator
    }
}

public extension Clause {
    func render() -> String {
        let renderer = ClauseRenderer(keyword, separator: separator)
        segments.forEach { $0.render(into: renderer) }
        return renderer.render()
    }
}
