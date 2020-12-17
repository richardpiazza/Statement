import Foundation

indirect enum Element<Context>: AnyElement {
    case table(String)
    case column(Column)
    case on(Column, Column)
    case predicate(Column, Predicate)
    case and(Element<Context>)
    case or(Element<Context>)
    
    func render<C>(into renderer: ClauseRenderer<C>) {
        renderer.addElement(self)
    }
}
