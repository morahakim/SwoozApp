//
//  Lottie.swift
//  Swooz
//
//  Created by Agung Saputra on 28/10/23.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    let name: String

    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView(frame: .zero)
        let animationView = LottieAnimationView(name: name)
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFill
        animationView.play()
        view.addSubview(animationView)

        animationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
