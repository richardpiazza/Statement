import Foundation

class GroupRenderer: Renderer {
    let prefix: String
    let suffix: String
    let separator: String
    var components: [String] = []
    
    init(prefix: String, suffix: String, separator: String) {
        self.prefix = prefix
        self.suffix = suffix
        self.separator = separator
    }
    
    func render() -> String {
        return prefix + " " + components.joined(separator: separator) + " " + suffix
    }
}
