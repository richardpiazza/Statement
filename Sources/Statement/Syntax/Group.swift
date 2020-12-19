import Foundation

struct Group<Context> {
    var segments: [AnyRenderable]
    var prefix: String = "("
    var suffix: String = ")"
    var separator: String = ", "
}

extension Group {
    func render() -> String {
        let renderer = GroupRenderer(prefix: prefix, suffix: suffix, separator: separator)
        segments.forEach { $0.render(into: renderer) }
        return renderer.render()
    }
}

extension Group: AnyRenderable {
    func render(into renderer: Renderer) {
        renderer.addGroup(self)
    }
}
