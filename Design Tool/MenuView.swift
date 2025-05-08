// MenuView.swift
import SwiftUI

struct MenuView: View {
    @Binding var showMenu: Bool
    @Binding var currentCardType: CardType
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Menu Items
            Button(action: {
                currentCardType = .object
                showMenu = false
                generateHapticFeedback()
            }) {
                Text("Objects")
                    .foregroundColor(.white)
                    .font(.headline)
                    .padding(.horizontal, 20)
            }
            
            Button(action: {
                currentCardType = .vocabulary
                showMenu = false
                generateHapticFeedback()
            }) {
                Text("Visual Language")
                    .foregroundColor(.white)
                    .font(.headline)
                    .padding(.horizontal, 20)
            }
            
            Button(action: {
                currentCardType = .material
                showMenu = false
                generateHapticFeedback()
            }) {
                Text("Materials")
                    .foregroundColor(.white)
                    .font(.headline)
                    .padding(.horizontal, 20)
            }
            
            Button(action: {
                currentCardType = .degradation
                showMenu = false
                generateHapticFeedback()
            }) {
                Text("Mechanisms")
                    .foregroundColor(.white)
                    .font(.headline)
                    .padding(.horizontal, 20)
            }
            
        
            
            NavigationLink(destination: TestView()) {
                Text("Test")
                    .foregroundColor(.white)
                    .font(.headline)
                    .padding(.horizontal, 20)
            }
            
            Spacer()
        }
        .padding(.top, 100)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.black)
        .shadow(radius: 5)
        .padding(.top, 0)
        .frame(maxHeight: .infinity, alignment: .topLeading)
    }
}
