import SwiftUI

class EmojiMemoryGame: ObservableObject {
    static let availableThemes: [Theme] = [
        Theme(name: "Suits",
              contents: ["❤️", "♠️", "♦️", "♣️"],
              color: "red"),
        Theme(name: "Zodiacs",
              contents: ["♈️", "♉️", "♊️", "♋️", "♌️", "♍️", "♎️", "♏️", "♐️", "♑️", "♒️", "♓️"],
              color: "purple"),
        Theme(name: "Aline",
              contents: ["🪐", "🔮", "🎀", "🩷", "❤️‍🔥", "🦕", "🧚🏻‍♀️", "🧝🏻‍♀️", "🧟‍♀️", "🫦", "👌🏻", "🙂‍↔️"],
              color: "pink")]
    
    private static func createMemoryGame() -> MemoryGame<String> {
        let theme = availableThemes.randomElement()
        let unwrappedTheme = theme!
        let selectedEmojis = unwrappedTheme.contents.shuffled()
        
        return MemoryGame(currentTheme: unwrappedTheme, 
                          numberOfPairsOfCards: Int.random(in: 4...selectedEmojis.count))
        { pairIndex in
            if selectedEmojis.indices.contains(pairIndex) {
                return selectedEmojis[pairIndex]
            } else {
                return "⁉️"
            }
        }
    }
    
    
    @Published private var model = createMemoryGame()
    
    var cards: [MemoryGame<String>.Card] {
        return model.cards
    }
    
    func startNewGame() {
        model = EmojiMemoryGame.createMemoryGame()
    }
    
    func shuffle() {
        model.shuffle()
    }
    
    func choose(_ card: MemoryGame<String>.Card) {
        model.choose(card)
    }
    
    func getScore() -> Int {
        model.currentScore
    }
    
    func getColor() -> Color {
        let currentColor: Color
        
        switch(model.currentTheme.color) {
        case "red":
            currentColor = .red
        case "purple":
            currentColor = .purple
        case "pink":
            currentColor = .pink
        default:
            currentColor = .blue
        }
        
        return currentColor
    }
    
    func getName() -> String {
        model.currentTheme.name
    }
}
