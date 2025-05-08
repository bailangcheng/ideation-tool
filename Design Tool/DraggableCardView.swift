import SwiftUI

struct DraggableCardView: View {
    var card: AnyCard
    var onRemove: (ContentView.SwipeDirection) -> Void
    var externalOffset: CGSize = .zero
    var externalRotation: Double = 0.0

    @GestureState private var dragState = DragState.inactive
    @State private var isSelected = false
    @State private var scale: CGFloat = 1.0
    @State private var currentOffset: CGSize = .zero

    var body: some View {
        cardView()
            .scaleEffect(scale)
            .animation(.easeInOut, value: scale)
            .offset(x: currentOffset.width + externalOffset.width, y: currentOffset.height + externalOffset.height)
            .rotationEffect(Angle(degrees: Double(currentOffset.width / 50) + externalRotation))
            .gesture(combinedGesture)
            .onAppear {
                currentOffset = .zero
                scale = 1.0
            }
            .onChange(of: card) { _ in
                currentOffset = .zero
                scale = 1.0
                isSelected = false
            }
    }

    @ViewBuilder
    func cardView() -> some View {
        switch card {
        case .object(let objectCard):
            ObjectCardView(card: objectCard)
        case .material(let materialCard):
            MaterialCardView(card: materialCard)
        case .degradation(let degradationCard):
            DegradationCardView(card: degradationCard)
        case .vocabulary(let vocabularyCard):
            VocabularyCardView(card: vocabularyCard)
        }
    }

    enum DragState {
        case inactive
        case dragging(translation: CGSize)

        var translation: CGSize {
            switch self {
            case .inactive:
                return .zero
            case .dragging(let translation):
                return translation
            }
        }
    }

    var combinedGesture: some Gesture {
        let longPress = LongPressGesture(minimumDuration: 0.3)
            .onEnded { _ in
                withAnimation {
                    self.isSelected = true
                    self.scale = 1.05
                }
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.impactOccurred()
            }

        let drag = DragGesture()
            .updating($dragState) { value, state, _ in
                if isSelected {
                    state = .dragging(translation: value.translation)
                }
            }
            .onChanged { value in
                if isSelected {
                    currentOffset = value.translation
                }
            }
            .onEnded { value in
                guard isSelected else { return }

                if abs(value.translation.width) > 100 {
                    let direction: ContentView.SwipeDirection = value.translation.width > 0 ? .right : .left
                    self.onRemove(direction)
                } else {
                    withAnimation {
                        currentOffset = .zero
                    }
                }

                withAnimation {
                    self.isSelected = false
                    self.scale = 1.0
                }
            }

        return longPress.sequenced(before: drag)
    }
}
