import Foundation

protocol Renderer {
    func addRaw(_ text: String)
    func addElement(_ element: Element)
}

class ClauseRenderer: Renderer {
    let keyword: Keyword
    private var rendered: String = ""
    private var lastElement: AnyElement?
    
    init(_ keyword: Keyword) {
        self.keyword = keyword
        rendered = keyword.value
    }
    
    func render() -> String {
        return rendered
    }
}

extension ClauseRenderer {
    func addRaw(_ text: String) {
        rendered += text
    }
    
    func addElement(_ element: Element) {
        switch element {
        case .table(let table):
            addTable(table.schema.name)
        case .column(let column):
            addColumn(column)
        case .on(let c1, let c2):
            addOn(c1, c2)
        case .expression(let column, let predicate):
            addPredicate(column, predicate)
        case .and(let elements):
            let count = elements.count
            elements.enumerated().forEach {
                addElement($1)
                if $0 < count - 1 {
                    rendered += " AND"
                }
            }
        case .or(let elements):
            let count = elements.count
            elements.enumerated().forEach {
                addElement($1)
                if $0 < count - 1 {
                    rendered += " OR"
                }
            }
        }
        
        lastElement = element
    }
}

private extension ClauseRenderer {
    func addTable(_ table: String) {
        if rendered.last == " " {
            rendered += table
        } else {
            rendered += " " + table
        }
    }
    
    func addColumn(_ column: Column) {
        let join = (lastElement == nil) ? "" : ","
        rendered += "\(join) \(type(of: column).tableName).\(column.stringValue)"
    }
    
    func addOn(_ c1: Column, _ c2: Column) {
        var line: String = " ON "
        line += "\(type(of: c1).tableName).\(c1.stringValue)"
        line += " = "
        line += "\(type(of: c2).tableName).\(c2.stringValue)"
        rendered += line
    }
    
    func addPredicate(_ column: Column, _ predicate: OldPredicate) {
        var line: String = " "
        line += "\(type(of: column).tableName).\(column.stringValue)"
        line += " \(predicate.operator) "
        
        switch predicate {
        case .equal(let encodable):
            line += "\"\(string(from: encodable))\""
        case .notEqual(let encodable):
            line += string(from: encodable)
        case .greaterThan(let encodable):
            line += string(from: encodable)
        case .greaterThanEqualTo(let encodable):
            line += string(from: encodable)
        case .lessThan(let encodable):
            line += string(from: encodable)
        case .lessThanEqualTo(let encodable):
            line += string(from: encodable)
        case .`in`(let encodables):
            line += "[" + encodables.map { string(from: $0) }.joined(separator: ",") + "]"
        case .between(let first, let second):
            line += string(from: first) + " AND " + string(from: second)
        case .like(let encodable):
            line += string(from: encodable)
        case .isNull:
            break
        case .isNotNull:
            break
        }
        
        rendered += line
    }
    
    func string(from encodable: Encodable) -> String {
        switch encodable {
        case is String:
            return (encodable as! String)
        case is Int:
            return "\(encodable as! Int)"
        case is Double:
            return "\(encodable as! Double)"
        default:
            return "\(String(describing: encodable))"
        }
    }
}