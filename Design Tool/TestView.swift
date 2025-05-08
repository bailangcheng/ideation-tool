// ThreeDView.swift
import SwiftUI
import SplineRuntime


struct TestView: View {
    var body: some View {
        let url = URL(string: "https://build.spline.design/TR8Kn0-xtvWDETYQPC2v/scene.splineswift")!

        // fetching from local
        // let url = Bundle.main.url(forResource: "scene", withExtension: "splineswift")!

        SplineView(sceneFileURL: url).ignoresSafeArea(.all)
    }
}
