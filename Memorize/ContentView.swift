
import SwiftUI

struct ContentView: View {
    @State var emojis: [String] = []
    
    let suits = ["❤️", "♠️", "♦️", "♣️"]
    let shapes = ["⬜️", "🔵", "🔺", "🔶", "🟩", "🟣", "🛑"]
    let zodiacs = ["♈️", "♉️", "♊️", "♋️", "♌️", "♍️", "♎️", "♏️", "♐️", "♑️", "♒️", "♓️"]
    let alina = ["🪐", "🔮", "🎀", "🩷", "❤️‍🔥", "🦕", "🧚🏻‍♀️", "🧝🏻‍♀️", "🧟‍♀️", "🫦", "👌🏻", "🙂‍↔️"]
    
    @State var cardCount = 0
    @State var cardColor: Color = .white
    @State var randomRange: [Int] = []
    
    var body: some View {
        VStack {
            Text("Memorize!").font(.largeTitle)
            ScrollView {
                cards
            }
            Spacer()
            themeSelector
        }
        .padding()
    }
    
    var cards: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 120))]) {
            ForEach(0..<cardCount, id: \.self) { index in
                CardView(content: emojis[randomRange[index]], isFaceUp: false)
                    .aspectRatio(2/3, contentMode: .fit)
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
        case "Shapes":
            chosenEmojis = shapes
            cardColor = .cyan
        case "Alina":
            chosenEmojis = alina
            cardColor = Color(red: 100, green: 188, blue: 500)
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
            shapesThemeChooser
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
    
    var shapesThemeChooser: some View {
        Button(action: {
            switchTheme(to: "Shapes")
        }, label: {
            VStack {
                Image(systemName: "octagon.fill")
                    .imageScale(.large)
                    .font(.largeTitle)
                Text("Shapes")
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
    let content: String
    @State var isFaceUp = true
    
    var body: some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: 12)
            Group {
                base.fill(.white)
                base.strokeBorder(lineWidth: 2)
                Text(content).font(.system(size: 100))
            }
            .opacity(isFaceUp ? 1 : 0)
            base.fill().opacity(isFaceUp ? 0 : 1)
        }
        .onTapGesture {
            isFaceUp.toggle()
        }
    }
}

#Preview {
    ContentView()
}
