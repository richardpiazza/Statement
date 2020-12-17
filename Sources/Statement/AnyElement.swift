import Foundation

protocol AnyElement {
    func render<C>(into renderer: ClauseRenderer<C>)
}
