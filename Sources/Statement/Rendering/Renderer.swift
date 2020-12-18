import Foundation

protocol Renderer {
    func addRaw(_ text: String)
    func addSegment<C>(_ segment: Segment<C>)
}
