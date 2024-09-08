
import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    
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
        AspectVGrid(viewModel.cards, aspectRatio: aspectRatio) { card in
            CardView(card: card, themeColor: viewModel.getColor())
                .padding(4)
                .onTapGesture {
                    viewModel.choose(card)
                }
        }
                
    }
}

struct CardView: View {
    let card: MemoryGame<String>.Card
    let themeColor: Color
    
    var body: some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: 12)
            Group {
                base.fill(.white)
                base.strokeBorder(lineWidth: 2)
                Text(card.content)
                    .font(.system(size: 100))
                    .minimumScaleFactor(0.01)
                    .aspectRatio(1, contentMode: .fit)
            }
            .opacity(card.isFaceUp ? 1 : 0)
            base.fill().opacity(card.isFaceUp ? 0 : 1)
        }
        .foregroundColor(themeColor)
        .opacity(card.isFaceUp || !card.isMatched ? 1 : 0)
    }
}

#Preview {
    EmojiMemoryGameView(viewModel: EmojiMemoryGame())
}
