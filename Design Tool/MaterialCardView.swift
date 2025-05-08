import SwiftUI

struct MaterialCardView: View {
    var card: MaterialCard
    
    let customFontName = "Inter"
    
    @State private var isFlipped = false
    
    // MARK: - Adjustable Parameters
    // Adjustable spacing between VStack elements
    var headerSpacing: CGFloat = 10
    var imageBottomSpacing: CGFloat = 20
    var nameBottomSpacing: CGFloat = 10
    var tagBottomSpacing: CGFloat = 15
    var descriptionSpacing: CGFloat = 10
    var methodsSpacing: CGFloat = 10 // 新增：方法图标与名称之间的间距
    
    // Adjustable padding inside the card
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
        .frame(width: 320, height: 450) // 固定卡片尺寸
        .animation(.easeInOut(duration: 0.6), value: isFlipped) // 翻转动画
        .onTapGesture {
            withAnimation { isFlipped.toggle() }
            generateHapticFeedback()
        }
        .shadow(color: Color.gray.opacity(0.1), radius: 5, x: 0, y: 0)
    }
    
    // Front View
    var frontView: some View {
        VStack(spacing: 0) {
            headerView
                .padding(.bottom, headerSpacing)
            
            if let materialImage = UIImage(named: card.image) {
                Image(uiImage: materialImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 150)
                    .padding(.bottom, imageBottomSpacing)
            } else {
                Rectangle()
                    .fill(Color.gray)
                    .frame(height: 150)
                    .padding(.bottom, imageBottomSpacing)
            }
            
            // Material name between image and tags
            Text(card.name)
                .font(.custom(customFontName, size: 24))
                .fontWeight(.bold)
                .foregroundColor(.black)
                .padding(.bottom, nameBottomSpacing)
            
            tagView
                .padding(.bottom, tagBottomSpacing)
            
            descriptionView(properties: card.properties, applications: card.applications)
                .padding(.bottom, descriptionSpacing)
            
            Spacer() // Fill remaining space to maintain fixed height
        }
        .background(Color.white)
        .cornerRadius(25)
        .frame(width: 320, height: 450) // 确保与ZStack的框架一致
    }
    
    // Back View
    var backView: some View {
        VStack(spacing: 0) {
            headerView
                .padding(.bottom, headerSpacing)
            
            // 方法图标和名称的容器
            methodsContainer
                .padding(.bottom, imageBottomSpacing)
            
            // 标题
            Text(card.name)
                .font(.custom(customFontName, size: 24))
                .fontWeight(.medium)
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .padding(.horizontal, cardPadding)
                .padding(.bottom, nameBottomSpacing * 3)
            
            
            // 降解描述和降解时间
            descriptionView(
                degradationDescription: card.degradation_description,
                decompositionTime: card.decomposition_time
            )
                .padding(.bottom, descriptionSpacing)
            
            Spacer() // Fill remaining space to maintain fixed height
        }
        .background(Color(white: 1))
        .cornerRadius(25)
        .frame(width: 320, height: 450) // 确保与ZStack的框架一致
    }
    
    // 方法图标和名称的容器
    var methodsContainer: some View {
        VStack(spacing: methodsSpacing) {
            HStack(spacing: 20) {
                ForEach(card.degradation_methods.prefix(3), id: \.id) { method in
                    VStack {
                        if let methodImage = UIImage(named: method.image) {
                            Image(uiImage: methodImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                        } else {
                            Image(systemName: "leaf.arrow.circlepath")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                        }
                        Text(method.name)
                            .font(.custom(customFontName, size: 12))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                    }
                }
            }
            .frame(height: 150) // 与前视图中图像的高度一致
        }
        .padding(.horizontal, cardPadding)
    }
    
    // Header with title and degradation methods
    var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("Material")
                    .font(.custom(customFontName, size: 15))
                    .foregroundColor(.gray)
                Text("Card")
                    .font(.custom(customFontName, size: 15))
                    .foregroundColor(.gray)
            }
            Spacer()
            HStack(spacing: 5) {
                ForEach(card.degradation_methods.prefix(3), id: \.id) { method in
                    if let methodImage = UIImage(named: method.image) {
                        Image(uiImage: methodImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                    } else {
                        Image(systemName: "leaf.arrow.circlepath")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                    }
                }
            }
        }
        .padding(.horizontal, cardPadding)
        .padding(.top, cardPadding)
    }
    
    // Tags for type and source
    var tagView: some View {
        VStack(spacing: 5) {
            HStack {
                ForEach(card.type, id: \.self) { type in
                    Text(type.capitalized)
                        .font(.custom(customFontName, size: 12))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(Color.gray.opacity(0.3))
                        .cornerRadius(10)
                }
            }
            HStack {
                ForEach(card.source, id: \.self) { source in
                    Text(source.capitalized)
                        .font(.custom(customFontName, size: 12))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                }
            }
        }
        .padding(.horizontal, cardPadding)
    }
    
    // Description View for properties, applications or degradation details
    func descriptionView(properties: String? = nil, applications: String? = nil, degradationDescription: String? = nil, decompositionTime: String? = nil) -> some View {
        VStack(alignment: .leading, spacing: descriptionSpacing) {
            if let properties = properties {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Properties")
                        .font(.custom(customFontName, size: 12))
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                    Text(properties)
                        .font(.custom(customFontName, size: 12))
                        .foregroundColor(.gray)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            
            if let applications = applications {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Applications")
                        .font(.custom(customFontName, size: 12))
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                    Text(applications)
                        .font(.custom(customFontName, size: 12))
                        .foregroundColor(.gray)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            
            if let degradationDescription = degradationDescription {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Degradation Description")
                        .font(.custom(customFontName, size: 12))
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                    Text(degradationDescription)
                        .font(.custom(customFontName, size: 12))
                        .foregroundColor(.gray)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            
            if let decompositionTime = decompositionTime {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Degradation Time")
                        .font(.custom(customFontName, size: 12))
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                    Text(decompositionTime)
                        .font(.custom(customFontName, size: 12))
                        .foregroundColor(.gray)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .padding(.horizontal, cardPadding)
    }
}
