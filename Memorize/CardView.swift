import SwiftUI

struct CardView: View {
    typealias Card = MemoryGame<String>.Card
    
    let card: Card
    
    private struct Constants {
        static let inset: CGFloat = 5
        
        struct FontSize {
            static let largest: CGFloat = 200
            static let smallest: CGFloat = 10
            static let scaleFactor = smallest / largest
        }
        
        struct Pie {
            static let opacity: CGFloat = 0.5
            static let inset: CGFloat = 5
        }
    }
    
    var body: some View {
        TimelineView(.animation) { timeline in
            if (card.isFaceUp || !card.isMatched) {
                Pie(endAngle: .degrees(card.bonusPercentageRemaining * 360))
                    .opacity(Constants.Pie.opacity)
                    .overlay(cardContents.padding(Constants.Pie.inset))
                    .padding(Constants.inset)
                    .cardify(isFaceUp: card.isFaceUp)
                    .transition(.scale)
            } else {
                Color.clear
            }
        }
    }
    
    var cardContents: some View {
        Text(card.content)
            .font(.system(size: Constants.FontSize.largest))
            .minimumScaleFactor(Constants.FontSize.scaleFactor)
            .multilineTextAlignment(.center)
            .aspectRatio(1, contentMode: .fit)
            .rotationEffect(.degrees(card.isMatched ? 360 : 0))
            .animation(.spin(duration: 1), value: card.isMatched)
    }
}

extension Animation {
    static func spin(duration: TimeInterval) -> Animation {
        .linear(duration: duration).repeatForever(autoreverses: false)
    }
}

#Preview {
    VStack {
        HStack {
            CardView(card: MemoryGame<String>.Card(
                content: "X",
                isFaceUp: true,
                id: "test1"))

            CardView(card: MemoryGame<String>.Card(
                content: "X",
                id: "test1"))
                
        }
        HStack {
            CardView(card: MemoryGame<String>.Card(
                content: "This is a very long text and I hope it fits",
                isFaceUp: true,
                id: "test1"))

            CardView(card: MemoryGame<String>.Card(
                content: "X",
                isMatched: true,
                id: "test1"))
                
        }
    }
    .padding()
}
