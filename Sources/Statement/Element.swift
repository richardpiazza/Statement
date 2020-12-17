import Foundation

indirect enum Element<Context>: AnyElement {
    case table(Table.Type)
    case column(Column)
    case on(Column, Column)
    case predicate(Column, Predicate)
    case and(Element<Context>)
    case or(Element<Context>)
    
    func render(into renderer: ClauseRenderer) {
        renderer.addElement(self)
    }
}
