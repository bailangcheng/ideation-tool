import SwiftUI

struct VocabularyCardView: View {
    var card: VocabularyCard
    
    // Custom font
    let customFontName = "Inter"
    
    // Manage card flip state
    @State private var isFlipped = false
    
    // MARK: - Adjustable Parameters
    // Adjustable spacing between VStack elements
    var headerSpacing: CGFloat = 80        // 间距：Header与图标之间
    var imageBottomSpacing: CGFloat = 30   // 间距：图标与标题之间
    var titleBottomSpacing: CGFloat = 15   // 间距：标题与描述之间
    var descriptionSpacing: CGFloat = 10   // 间距：描述与底部之间
    
    // Adjustable padding inside the card
    var cardPadding: CGFloat = 20          // 内边距
    
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
        .frame(width: 320, height: 450) // 固定卡片尺寸
        .animation(.easeInOut(duration: 0.6), value: isFlipped) // 翻转动画
        .onTapGesture {
            withAnimation {
                isFlipped.toggle() // 切换翻转状态
            }
            generateHapticFeedback() // 添加触觉反馈
        }
        .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 0)
    }
    
    // Front View
    var frontView: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 0) {
                headerView
                    .padding(.bottom, headerSpacing) // 使用可调整的headerSpacing
                
                // 大型中央图标
                if let vocabImage = UIImage(named: card.image) {
                    Image(uiImage: vocabImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 100)
                        .padding(.bottom, imageBottomSpacing) // 使用可调整的imageBottomSpacing
                } else {
                    Rectangle()
                        .fill(Color.gray)
                        .frame(width: 100, height: 100)
                        .padding(.bottom, imageBottomSpacing)
                }
                
                // Vocabulary 标题
                Text(card.name)
                    .font(.custom(customFontName, size: 24))
                    .fontWeight(.medium)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, cardPadding) // 使用可调整的cardPadding
                    .padding(.bottom, titleBottomSpacing) // 使用可调整的titleBottomSpacing
                
                // 描述
                Text(card.description)
                    .font(.custom(customFontName, size: 14))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, cardPadding)
                    .padding(.bottom, descriptionSpacing)
                    .padding(.top, 20)
                    .lineSpacing(3)
                
                
                Spacer() // 填充剩余空间以保持固定高度
            }
            .frame(width: 320, height: 450) // 确保与ZStack的框架一致
            .background(Color.white)
            .cornerRadius(25)
            
            // 右上角黑色圆形
            Circle()
                .fill(Color.black)
                .frame(width: 20, height: 20)
                .padding(.top, cardPadding)
                .padding(.trailing, cardPadding)
        }
    }
    
    // Back View
    var backView: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 0) {
                headerView
                    .padding(.bottom, headerSpacing) // 使用可调整的headerSpacing
                
                // 大型中央图标
                if let vocabImage = UIImage(named: card.image) {
                    Image(uiImage: vocabImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 100)
                        .padding(.bottom, imageBottomSpacing) // 使用可调整的imageBottomSpacing
                } else {
                    Rectangle()
                        .fill(Color.gray)
                        .frame(width: 100, height: 100)
                        .padding(.bottom, imageBottomSpacing)
                }
                
                // Vocabulary 标题
                Text(card.name)
                    .font(.custom(customFontName, size: 24))
                    .fontWeight(.medium)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, cardPadding) // 使用可调整的cardPadding
                    .padding(.bottom, titleBottomSpacing) // 使用可调整的titleBottomSpacing
                
                // 设计洞察部分
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Design Insights")
                            .font(.custom(customFontName, size: 14))
                            .fontWeight(.medium)
                            .foregroundColor(.black)
                        
                        Spacer()
                        
                        // 使用资产中的"idea"图片
                        if let ideaImage = UIImage(named: "Idea") {
                            Image(uiImage: ideaImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                        }
                    }
                    
                    Text(card.design_insight)
                        .font(.custom(customFontName, size: 14))
                        .foregroundColor(.gray)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(cardPadding)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)
                .padding(.horizontal, cardPadding)
                .padding(.bottom, descriptionSpacing) // 使用可调整的descriptionSpacing
                
                Spacer() // 填充剩余空间以保持固定高度
            }
            .frame(width: 320, height: 450) // 确保与ZStack的框架一致
            .background(Color.white)
            .cornerRadius(25)
            
    
        }
    }
    
    // Header with title and degradation methods
    var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("Degradation")
                    .font(.custom(customFontName, size: 15))
                    .foregroundColor(.gray)
                Text("Vocabulary")
                    .font(.custom(customFontName, size: 15))
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding(.horizontal, cardPadding) // 使用可调整的cardPadding
        .padding(.top, cardPadding)         // 使用可调整的cardPadding
    }
}
