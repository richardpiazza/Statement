import Foundation

public protocol AnyRenderable {
    func render(into renderer: Renderer)
}
