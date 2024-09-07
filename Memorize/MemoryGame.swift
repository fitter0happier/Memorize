import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var cards: [Card]
    private(set) var currentTheme: Theme
    
    init(currentTheme: Theme, 
         numberOfPairsOfCards: Int,
         cardContentFactory: (Int) -> CardContent)
    {
        self.currentTheme = currentTheme
        cards = []
        for pairIndex in 0..<max(2, numberOfPairsOfCards) {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(content: content, id: "\(pairIndex + 1)a"))
            cards.append(Card(content: content, id: "\(pairIndex + 1)b"))
        }
        cards.shuffle()
    }
    
    var currentScore = 0
    
    var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            cards.indices.filter { index in cards[index].isFaceUp }.only
        }
        
        set {
            cards.indices.forEach { cards[$0].isFaceUp = ($0 == newValue) }
        }
    }
    
    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }) {
            if !cards[chosenIndex].isFaceUp && !cards[chosenIndex].isMatched {
                if let potentialMatchIndex = indexOfOneAndOnlyFaceUpCard {
                    if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                        cards[chosenIndex].isMatched = true
                        cards[potentialMatchIndex].isMatched = true
                        currentScore += 2
                    } else {
                        if cards[chosenIndex].isPreviouslySeen {
                            currentScore -= 1
                        }
                        
                        if cards[potentialMatchIndex].isPreviouslySeen {
                            currentScore -= 1
                        }
                        
                        cards[chosenIndex].isPreviouslySeen = true
                        cards[potentialMatchIndex].isPreviouslySeen = true
                    }
                    
                } else {
                    indexOfOneAndOnlyFaceUpCard = chosenIndex
                }
                
                cards[chosenIndex].isFaceUp = true
            }
        }
    }
    
    mutating func shuffle() {
        cards.shuffle()
    }
    
    struct Card: Equatable, Identifiable, CustomDebugStringConvertible {
        let content: CardContent
        
        var isPreviouslySeen = false
        var isFaceUp = false
        var isMatched = false
        var id: String
        var debugDescription: String {
            "\(id): \(content) \(isFaceUp ? "up" : "down") \(isMatched ? "matched" : "")"
        }
    }
}

extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}
