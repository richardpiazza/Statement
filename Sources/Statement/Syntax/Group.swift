import Foundation

public struct Group<Context> {
    public var segments: [Renderable]
    public var prefix: String
    public var suffix: String
    public var separator: String
    
    public init(segments: [Renderable], prefix: String = "(", suffix: String = ")", separator: String = ", ") {
        self.segments = segments
        self.prefix = prefix
        self.suffix = suffix
        self.separator = separator
    }
}

public extension Group {
    func render() -> String {
        let renderer = GroupRenderer(prefix: prefix, suffix: suffix, separator: separator)
        segments.forEach { $0.render(into: renderer) }
        return renderer.render()
    }
}

extension Group: Renderable {
    public func render(into renderer: Renderer) {
        renderer.addGroup(self)
    }
}
