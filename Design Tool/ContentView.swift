import SwiftUI

struct ContentView: View {
    @State private var currentCard: AnyCard?
    @State private var nextCard: AnyCard?
    @State private var cards: [AnyCard] = []
    @State private var currentIndex: Int = 0
    @State private var showMenu = false
    @State private var currentCardType: CardType = .object

    @State private var currentCardOffset = CGSize.zero
    @State private var currentCardRotation: Double = 0
    @State private var nextCardOffset = CGSize(width: 0, height: 0)
    @State private var nextCardRotation: Double = 0

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    HStack {
                        Button(action: {
                            withAnimation {
                                self.showMenu.toggle()
                            }
                        }) {
                            Image(systemName: "line.horizontal.3")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, height: 25)
                                .foregroundColor(.black)
                        }
                        .padding()
                        
                        Spacer()
                        
                        NavigationLink(destination: TimerView(viewModel: TimerViewModel())) {
                            Image(systemName: "timer")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, height: 25)
                                .foregroundColor(.black)
                        }
                        .padding()
                    }
                    .padding(.top, 40)
                    
                    Spacer()
                    
                    ZStack {
                        if let nextCard = nextCard {
                            DraggableCardView(
                                card: nextCard,
                                onRemove: { _ in }
                            )
                            .offset(nextCardOffset)
                            .rotationEffect(.degrees(nextCardRotation))
                            .onAppear {
                                withAnimation(Animation.easeInOut(duration: 0.6)) {
                                    nextCardOffset = .zero
                                    nextCardRotation = 0
                                }
                            }
                        }
                        
                        if let currentCard = currentCard {
                            DraggableCardView(
                                card: currentCard,
                                onRemove: { direction in
                                    self.handleSwipe(direction: direction)
                                },
                                externalOffset: currentCardOffset,
                                externalRotation: currentCardRotation
                            )
                            .id(currentCard.id)
                        }
                    }
                    .frame(width: 320, height: 450)
                    
                    Spacer(minLength: 5)
                    
                    Button(action: {
                        shuffleCurrentCard()
                        generateHapticFeedback()
                    }) {
                        Text("Shuffle")
                            .padding()
                            .frame(width: 200, height: 50)
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(25)
                            .shadow(radius: 5)
                    }
                    .padding(.bottom, 40)
                }
                
                if showMenu {
                    HStack(spacing: 0) {
                        MenuView(showMenu: $showMenu, currentCardType: $currentCardType)
                            .frame(width: 200)
                            .transition(.move(edge: .leading))
                            .animation(.easeInOut, value: showMenu)
                        
                        Color.black.opacity(0.0)
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                                withAnimation {
                                    showMenu = false
                                }
                            }
                            .gesture(
                                DragGesture()
                                    .onEnded { gesture in
                                        if gesture.translation.width < -50 {
                                            withAnimation {
                                                showMenu = false
                                            }
                                        }
                                    }
                            )
                    }
                    .edgesIgnoringSafeArea(.all)
                }
            }
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                loadInitialCards()
            }
            .onChange(of: currentCardType) { _ in
                loadInitialCards()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func loadInitialCards() {
        cards = loadCards(for: currentCardType)
        if !cards.isEmpty {
            currentIndex = 0
            currentCard = cards[currentIndex]
            nextCard = nil
            currentCardOffset = .zero
            currentCardRotation = 0
        } else {
            currentCard = nil
            nextCard = nil
        }
    }
    
    func handleSwipe(direction: SwipeDirection) {
        guard !cards.isEmpty else { return }
        
        var nextIndex = currentIndex
        if direction == .left {
            nextIndex = (currentIndex + 1) % cards.count
        } else if direction == .right {
            nextIndex = (currentIndex - 1 + cards.count) % cards.count
        }
        
        let screenWidth = UIScreen.main.bounds.width
        let xOffset = direction == .left ? screenWidth : -screenWidth
        let rotation = direction == .left ? 15 : -15
        
        nextCardOffset = CGSize(width: xOffset, height: -100)
        nextCardRotation = Double(rotation)
        nextCard = cards[nextIndex]
        
        withAnimation(Animation.easeInOut(duration: 0.5)) {
            let exitOffset = direction == .left ? -screenWidth : screenWidth
            let exitRotation = direction == .left ? -15 : 15
            currentCardOffset = CGSize(width: exitOffset, height: -100)
            currentCardRotation = Double(exitRotation)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            currentCard = nextCard
            currentIndex = nextIndex
            nextCard = nil
            
            currentCardOffset = .zero
            currentCardRotation = 0
        }
    }
    
    func shuffleCurrentCard() {
        guard !cards.isEmpty else { return }
        
        var newIndex = currentIndex
        repeat {
            newIndex = Int.random(in: 0..<cards.count)
        } while newIndex == currentIndex && cards.count > 1
        
        currentCard = cards[newIndex]
        currentIndex = newIndex
    }
    
    func generateHapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    enum SwipeDirection {
        case left
        case right
    }
    
    func loadCards(for type: CardType) -> [AnyCard] {
        let fileName: String
        switch type {
        case .object:
            fileName = "data-object"
        case .material:
            fileName = "data-material"
        case .degradation:
            fileName = "data-degradation"
        case .vocabulary:
            fileName = "data-vocabulary"
        }
        
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                switch type {
                case .object:
                    let objectCards = try decoder.decode([ObjectCard].self, from: data)
                    return objectCards.map { AnyCard.object($0) }
                case .material:
                    let materialCards = try decoder.decode([MaterialCard].self, from: data)
                    return materialCards.map { AnyCard.material($0) }
                case .degradation:
                    let degradationCards = try decoder.decode([DegradationCard].self, from: data)
                    return degradationCards.map { AnyCard.degradation($0) }
                case .vocabulary:
                    let vocabularyCards = try decoder.decode([VocabularyCard].self, from: data)
                    return vocabularyCards.map { AnyCard.vocabulary($0) }
                }
            } catch {
                print("Failed to decode \(fileName) cards: \(error)")
            }
        } else {
            print("Cannot find \(fileName).json file")
        }
        return []
    }
}
