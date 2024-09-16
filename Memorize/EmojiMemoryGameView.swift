
import SwiftUI

struct EmojiMemoryGameView: View {
    typealias Card = MemoryGame<String>.Card
    
    @ObservedObject var viewModel: EmojiMemoryGame
    
    private let spacing:CGFloat = 4
    private let aspectRatio:CGFloat = 2/3
    private let dealAnimation: Animation = .easeOut(duration: 0.5)
    private let dealInterval: TimeInterval = 0.05
    private let deckWidth: CGFloat = 50
    
    var body: some View {
        VStack {
            HStack{
                themeName
                Spacer()
                deck.foregroundColor(viewModel.getColor())
                Spacer()
                score
            }
                .padding(10)
                .font(.largeTitle)
            
            cards
            newGameButton
            
        }
            .padding()
    }
    
    private var score: some View {
        Text("Score: \(viewModel.getScore())")
            .animation(nil)
    }
    
    private var themeName: some View {
        Text(viewModel.getName())
    }
    
    private var newGameButton: some View {
        Button("New Game") {
            withAnimation {
                viewModel.startNewGame()
            }
        }
            .font(.title)
    }

    private var cards: some View {
        AspectVGrid(viewModel.cards, aspectRatio: aspectRatio) 
        { card in
            if (isDealt(card)) {
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
                    .padding(spacing)
                    .overlay(FlyingNumber(number: scoreChange(causedBy: card)))
                    .zIndex(scoreChange(causedBy: card) != 0 ? 100 : 0)
                    .onTapGesture {
                        choose(card)
                    }
                    .foregroundColor(viewModel.getColor())
            }
        }
    }
    
    @State private var dealt = Set<Card.ID>()
    
    private func isDealt(_ card: Card) -> Bool {
        dealt.contains(card.id)
    }
    
    private var undealtCards: [Card] {
        viewModel.cards.filter { !isDealt($0) }
    }
    
    @Namespace private var dealingNamespace
    
    private var deck: some View {
        ZStack {
            ForEach(undealtCards) { card in
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
            }
        }
        .frame(width: deckWidth, height: deckWidth / aspectRatio)
        .onTapGesture {
            deal()
        }
    }
    
    private func deal() {
        var delay: TimeInterval = 0
        for card in viewModel.cards {
            withAnimation(dealAnimation.delay(delay)) {
                _ = dealt.insert(card.id)
            }
            delay += dealInterval
        }
    }
    
    private func choose(_ card: Card) {
        withAnimation {
            let scoreBeforeChoosing = viewModel.getScore()
            viewModel.choose(card)
            let scoreChange = viewModel.getScore() - scoreBeforeChoosing
            lastScoreChanged = (scoreChange, causedByCardId: card.id)
        }
    }
    
    @State private var lastScoreChanged = (0, causedByCardId: "")
    
    private func scoreChange(causedBy card: Card) -> Int {
        let (amount, id) = lastScoreChanged
        return card.id == id ? amount : 0
    }
}

#Preview {
    EmojiMemoryGameView(viewModel: EmojiMemoryGame())
}
