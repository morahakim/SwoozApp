//
//  SwiftUIView.swift
//  Swooz
//
//  Created by Agung Saputra on 16/10/23.
//

import SwiftUI

struct OnBoardingView: View {
    @AppStorage("isOnBoarding") var isOnBoarding: Bool = true
    @AppStorage("path") var path: Path = .home
    @State private var step = 0

    let transition: AnyTransition = .asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading))

    private let onboardingData = [
        "Players want long rallies but \noften struggle to find their weaknesses.",
        "We're here to help you understand your \ngame by analyzing your game.",
        "Boost your game through objective \nevaluation with simplified visuals!"
    ]

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    HStack {
                        Spacer()
                        Button {
                            isOnBoarding = false
                            path = .recording
                        } label: {
                            Text("Skip")
                                .font(Font.custom("SF Pro", size: 17))
                                .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.15))
                        }
                    }

                    /** onboarding image */
                    TabView(selection: $step) {
                    }
                    .animation(.easeInOut, value: step)
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                }

                /** onboarding indicator */
                VStack {
                    GeometryReader { geometry in
                        HStack(alignment: .center, spacing: 8) {
                            ForEach(0 ..< onboardingData.count, id: \.self) { index in
                                Circle()
                                    .frame(width: 10, height: 10)
                                    .foregroundColor(
                                        Color(red: 0.13, green: 0.75, blue: 0.45)
                                            .opacity(step == index ? 1 : 0.3)
                                    )
                            }
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color(red: 0.98, green: 0.99, blue: 0.98))
                        .cornerRadius(50)
                        .position(
                            x: geometry.size.width * 0.5,
                            y: geometry.size.height * 0.75
                        )
                    }
                }

                VStack {
                    Spacer()
                    Button {
                        if step == 2 {
                            isOnBoarding = false
                            path = .recording
                        } else {
                            step += 1
                        }
                    } label: {
                        BtnNext()
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }
}


struct BtnNext: View {
    var body: some View {
        HStack(alignment: .center, spacing: 4) {
            Text("Next")
                .font(Font.custom("SF Pro", size: 15))
                .foregroundColor(.white)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .frame(maxWidth: .infinity, alignment: .center)
        .background(Color(red: 0.13, green: 0.75, blue: 0.45))
        .cornerRadius(12)
    }
}

#Preview {
    OnBoardingView()
}
