// ObjectCardView.swift
import SwiftUI

struct ObjectCardView: View {
    var card: ObjectCard
    
    // Custom font
    let customFontName = "Inter"
    
    // Manage card flip state
    @State private var isFlipped = false
    
    var body: some View {
        ZStack {
            // Front View
            frontView
                .opacity(isFlipped ? 0.0 : 1.0)
                .rotation3DEffect(
                    Angle(degrees: isFlipped ? 180 : 0),
                    axis: (x: 0, y: 1, z: 0)
                )
            
            // Back View
            backView
                .opacity(isFlipped ? 1.0 : 0.0)
                .rotation3DEffect(
                    Angle(degrees: isFlipped ? 0 : -180),
                    axis: (x: 0, y: 1, z: 0)
                )
        }
        .frame(width: 320, height: 450)
        .animation(.easeInOut(duration: 0.6), value: isFlipped) // Flip animation
        .onTapGesture {
            withAnimation {
                isFlipped.toggle() // Toggle flip state
            }
            generateHapticFeedback() // Add haptic feedback
        }
        .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 0)
    }
    
    // Front View
    var frontView: some View {
        VStack(spacing: 10) {
            HStack {
                Text("Object\nCard")
                    .font(.custom(customFontName, size: 18))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .lineSpacing(2)
                    .padding(.top, 10)
                    .padding(.leading, 10)
                Spacer()
            }
            
            // Display image or placeholder
            if UIImage(named: card.image) != nil {
                Image(card.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .grayscale(1.0)
                    .padding()
            } else {
                Circle()
                    .fill(Color.black)
                    .frame(width: 200, height: 200)
                    .scaleEffect(0.75)
                    .padding()
            }
            
            Text(card.name)
                .font(.custom(customFontName, size: 24))
                .fontWeight(.medium)
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
            
            Text(card.categories.joined(separator: ", "))
                .font(.custom(customFontName, size: 16))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .lineSpacing(3)
            
            Spacer()
        }
        .padding()
        .frame(width: 320, height: 450)
        .background(Color.white) // Front background color
        .cornerRadius(25)
    }
    
    // Back View
    var backView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(" ")
                .font(.custom(customFontName, size: 24))
                .fontWeight(.medium)
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .padding()
            
            // Add more back information here
            Text("Think about the about lifecycle of this object?")
                .font(.custom(customFontName, size: 16))
                .foregroundColor(.black)
                .multilineTextAlignment(.leading)
                .padding()
            
         
            Text("How is it used?")
                .font(.custom(customFontName, size: 16))
                .foregroundColor(.black)
                .multilineTextAlignment(.leading)
                .padding()
            
            Text("What happens at the end of its life?")
                .font(.custom(customFontName, size: 16))
                .foregroundColor(.black)
                .multilineTextAlignment(.leading)
                .padding()
            
            Spacer()
        }
        .padding()
        .frame(width: 320, height: 450)
        .background(Color(white: 0.98)) // Back background color
        .cornerRadius(25)
    }
}

