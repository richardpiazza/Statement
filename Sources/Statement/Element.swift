import Foundation

indirect enum Element: AnyElement {
    case table(Table.Type)
    case column(Column)
    case on(Column, Column)
    case expression(Column, OldPredicate)
    case and([Element])
    case or([Element])
    
    func render(into renderer: Renderer) {
        renderer.addElement(self)
    }
}
