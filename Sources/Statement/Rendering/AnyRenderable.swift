import Foundation

@available(*, deprecated, renamed: "Renderable")
public typealias AnyRenderable = Renderable

public protocol Renderable: Sendable {
    func render(into renderer: Renderer)
}
