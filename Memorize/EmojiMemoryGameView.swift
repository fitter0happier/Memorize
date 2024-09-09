
import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    
    private let spacing:CGFloat = 4
    private let aspectRatio:CGFloat = 2/3
    
    var body: some View {
        VStack {
            HStack{
                Text(viewModel.getName())
                Spacer()
                Text("Score: \(viewModel.getScore())")
            }
            .padding(10)
            .font(.largeTitle)
            
                cards.animation(.default, value: viewModel.cards)
            
            Button("New Game") {
                viewModel.startNewGame()
            }
            .font(.title)
        }
        .padding()
    }

    private var cards: some View {
        AspectVGrid(viewModel.cards, aspectRatio: aspectRatio) 
        { card in
            CardView(card: card)
                .padding(spacing)
                .onTapGesture {
                    viewModel.choose(card)
                }
                .foregroundColor(viewModel.getColor())
        }
                
    }
}

#Preview {
    EmojiMemoryGameView(viewModel: EmojiMemoryGame())
}
