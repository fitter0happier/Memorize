
import SwiftUI

struct EmojiMemoryGameView: View {
    typealias Card = MemoryGame<String>.Card
    
    @ObservedObject var viewModel: EmojiMemoryGame
    
    private let spacing:CGFloat = 4
    private let aspectRatio:CGFloat = 2/3
    
    var body: some View {
        VStack {
            HStack{
                themeName
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
            CardView(card: card)
                .padding(spacing)
                .overlay(FlyingNumber(number: scoreChange(causedBy: card)))
                .onTapGesture {
                    withAnimation {
                        viewModel.choose(card)
                    }
                }
                .foregroundColor(viewModel.getColor())
        }
    }
    
    private func scoreChange(causedBy card: Card) -> Int {
        return 0
    }
}

#Preview {
    EmojiMemoryGameView(viewModel: EmojiMemoryGame())
}
