import SwiftUI

struct DegradationCardView: View {
    var card: DegradationCard
    
    // Custom font
    let customFontName = "Inter"
    
    // Manage card flip state
    @State private var isFlipped = false
    
    // MARK: - Adjustable Parameters
    var headerSpacing: CGFloat = 80
    var imageBottomSpacing: CGFloat = 30
    var titleBottomSpacing: CGFloat = 10
    var descriptionSpacing: CGFloat = 10
    var cardPadding: CGFloat = 20
    
    var body: some View {
        ZStack {
            frontView
                .opacity(isFlipped ? 0.0 : 1.0)
                .rotation3DEffect(
                    Angle(degrees: isFlipped ? 180 : 0),
                    axis: (x: 0, y: 1, z: 0)
                )
            
            backView
                .opacity(isFlipped ? 1.0 : 0.0)
                .rotation3DEffect(
                    Angle(degrees: isFlipped ? 0 : -180),
                    axis: (x: 0, y: 1, z: 0)
                )
        }
        .frame(width: 320, height: 450)
        .animation(.easeInOut(duration: 0.6), value: isFlipped)
        .onTapGesture {
            withAnimation {
                isFlipped.toggle()
            }
            generateHapticFeedback()
        }
        .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 0)
    }
    
    // Front View
    var frontView: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 0) {
                headerView
                    .padding(.bottom, headerSpacing)
                
                iconView // 动态图标视图
                
                Text(card.name)
                    .font(.custom(customFontName, size: 24))
                    .fontWeight(.medium)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .padding(.horizontal, cardPadding)
                    .padding(.bottom, titleBottomSpacing)
                
                Text(card.description)
                    .font(.custom(customFontName, size: 13))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, cardPadding)
                    .padding(.bottom, descriptionSpacing)
                    .padding(.top, descriptionSpacing * 2)
                    .lineSpacing(3)
                
                Spacer()
            }
            .frame(width: 320, height: 450)
            .background(Color.white)
            .cornerRadius(25)
        }
    }
    
    // Back View
    var backView: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 0) {
                headerView
                    .padding(.bottom, headerSpacing)
                
                iconView // 动态图标视图
                
                Text(card.name)
                    .font(.custom(customFontName, size: 24))
                    .fontWeight(.medium)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .padding(.horizontal, cardPadding)
                    .padding(.bottom, titleBottomSpacing)
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Design Insights")
                            .font(.custom(customFontName, size: 14))
                            .fontWeight(.medium)
                            .foregroundColor(.black)
                        
                        Spacer()
                        if let ideaImage = UIImage(named: "Idea") {
                            Image(uiImage: ideaImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                        }
                    }
                    
                    Text(card.design_insights)
                        .font(.custom(customFontName, size: 13))
                        .foregroundColor(.gray)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(cardPadding)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)
                .padding(.horizontal, cardPadding)
                .padding(.bottom, descriptionSpacing)
                
                Spacer()
            }
            .frame(width: 320, height: 450)
            .background(Color.white)
            .cornerRadius(25)
        }
    }
    
    // 动态图标视图，根据图标数量调用不同的视图方法
    var iconView: some View {
        Group {
            if card.images.count == 1 {
                singleImageView()
            } else {
                multipleImagesView()
            }
        }
    }
    
    // 单张图片的视图
    @ViewBuilder
    private func singleImageView() -> some View {
        if let image = UIImage(named: card.images[0]) {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .padding(.bottom, imageBottomSpacing)
                .frame(maxWidth: .infinity, alignment: .center)
        } else {
            Rectangle()
                .fill(Color.gray)
                .frame(width: 100, height: 100)
                .padding(.bottom, imageBottomSpacing)
                .frame(maxWidth: .infinity, alignment: .center)
        }
    }
    
    // 多张图片的视图
    @ViewBuilder
    private func multipleImagesView() -> some View {
        HStack(spacing: 10) {
            ForEach(card.images.prefix(3), id: \.self) { imageName in
                if let image = UIImage(named: imageName) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .padding(.bottom, imageBottomSpacing)
                } else {
                    Rectangle()
                        .fill(Color.gray)
                        .frame(width: 60, height: 60)
                        .padding(.bottom, imageBottomSpacing)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
    
    // Header with title and degradation methods
    var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("Mechanism")
                    .font(.custom(customFontName, size: 15))
                    .foregroundColor(.gray)
                Text("Card")
                    .font(.custom(customFontName, size: 15))
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding(.horizontal, cardPadding)
        .padding(.top, cardPadding)
    }
}
