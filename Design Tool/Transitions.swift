// Transitions.swift
import SwiftUI

// FlipEffect - 定义用于卡片翻转的动画效果
struct FlipEffect: AnimatableModifier {
    var angle: Double
    let axis: (x: CGFloat, y: CGFloat, z: CGFloat) // 三维轴
    
    var animatableData: Double {
        get { angle }
        set { angle = newValue }
    }
    
    func body(content: Content) -> some View {
        content
            .rotation3DEffect(
                Angle(degrees: angle),
                axis: axis,
                perspective: 0.8
            )
    }
}

// 自定义过渡效果：flipFromBottom
extension AnyTransition {
    static var flipFromBottom: AnyTransition {
        .modifier(
            active: FlipEffect(angle: 180, axis: (x: 1, y: 0, z: 0)),
            identity: FlipEffect(angle: 0, axis: (x: 1, y: 0, z: 0))
        )
    }
}
