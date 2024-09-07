import Foundation

struct Theme {
    let name: String
    let contents: [String]
    let color: String
    
    init(name: String, contents: [String], color: String) {
        self.name = name
        self.contents = contents
        self.color = color
    }
}
