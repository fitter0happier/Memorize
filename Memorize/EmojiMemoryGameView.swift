
import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    
    @State var emojis: [String] = []
    
    let suits = ["❤️", "♠️", "♦️", "♣️"]
    let zodiacs = ["♈️", "♉️", "♊️", "♋️", "♌️", "♍️", "♎️", "♏️", "♐️", "♑️", "♒️", "♓️"]
    let alina = ["🪐", "🔮", "🎀", "🩷", "❤️‍🔥", "🦕", "🧚🏻‍♀️", "🧝🏻‍♀️", "🧟‍♀️", "🫦", "👌🏻", "🙂‍↔️"]
    
    @State var cardCount = 0
    @State var cardColor: Color = .purple
    @State var randomRange: [Int] = []
    
    var body: some View {
        VStack {
            Text("Memorize!").font(.largeTitle)
            ScrollView {
                cards.animation(.default, value: viewModel.cards)
            }
            Button("Shuffle") {
                viewModel.shuffle()
            }
            themeSelector
        }
        .padding()
    }
    
    var cards: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 85), spacing: 0)]) {
            ForEach(viewModel.cards) { card in
                CardView(card)
                    .aspectRatio(2/3, contentMode: .fit)
                    .padding(4)
                    .onTapGesture {
                        viewModel.choose(card)
                    }
            }
            
        }
        .foregroundColor(cardColor)
    }
    
    func switchTheme (to theme: String) -> () {
        emojis = []
        var chosenEmojis: [String]
        
        switch theme {
        case "Suits":
            chosenEmojis = suits
            cardColor = .pink
        case "Alina":
            chosenEmojis = alina
            cardColor = .purple
        default:
            chosenEmojis = zodiacs
            cardColor = .purple
            
        }
        
        for item in chosenEmojis {
            let amount = Int.random(in: 1...1)
            for _ in 0..<amount * 2 {
                emojis.append(item)
            }
        }
    
        cardCount = emojis.count
        randomRange = Array(0..<cardCount).shuffled()
    }
    
    var themeSelector: some View {
        HStack {
            suitsThemeChooser
            Spacer()
            zodiacsThemeChooser
            Spacer()
            alinaThemeChooser
        }
    }
    
    var suitsThemeChooser: some View {
        Button(action: {
            switchTheme(to: "Suits")
        }, label: {
            VStack {
                Image(systemName: "suit.spade.fill")
                    .imageScale(.large)
                    .font(.largeTitle)
                Text("Suits")
            }
        })
    }
    
    var zodiacsThemeChooser: some View {
        Button(action: {
            switchTheme(to: "Zodiacs")
        }, label: {
            VStack {
                Image(systemName: "moon.fill")
                    .imageScale(.large)
                    .font(.largeTitle)
                Text("Zodiacs")
            }
        })
        
    }
    
    var alinaThemeChooser: some View {
        Button(action: {
            switchTheme(to: "Alina")
        }, label: {
            VStack {
                Image(systemName: "sofa.fill")
                    .imageScale(.large)
                    .font(.largeTitle)
                Text("Alina")
            }
        })
        
    }
}

struct CardView: View {
    let card: MemoryGame<String>.Card
    
    init(_ card: MemoryGame<String>.Card) {
        self.card = card
    }
    
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
        .opacity(card.isFaceUp || !card.isMatched ? 1 : 0)
    }
}

#Preview {
    EmojiMemoryGameView(viewModel: EmojiMemoryGame())
}
