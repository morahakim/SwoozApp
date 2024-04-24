//
//  SwiftUIView.swift
//  Swooz
//
//  Created by Agung Saputra on 16/10/23.
//

import SwiftUI

struct OnBoardingView: View {
    @AppStorage("isOnBoarding") var isOnBoarding: Bool = true
    @AppStorage("path") var path: Path = .Home
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
                            path = .Recording
                        } label: {
                            Text("Skip")
                                .font(Font.custom("SF Pro", size: 17))
                                .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.15))
                        }
                    }

                    /** onboarding image */
                    TabView(selection: $step) {
//                        ImgHero(
//                            tag: 0,
//                            name: "Onboarding0",
//                            desc: onboardingData[0],
//                            transition: transition,
//                            width: 250
//                        )
//                        ImgHero(
//                            tag: 1,
//                            name: "Onboarding1",
//                            desc: onboardingData[1],
//                            transition: transition,
//                            width: 350
//                        )
//                        ImgHero(
//                            tag: 2,
//                            name: "Onboarding2",
//                            desc: onboardingData[2],
//                            transition: transition,
//                            width: 250
//                        )
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
                            path = .Recording
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

// struct ImgHero: View {
//    var tag: Int
//    var name: String
//    var desc: String
//    var transition: AnyTransition
//    
//    var width: CGFloat = 300
//    
//    var body: some View {
//        VStack {
//            Image(name)
//                .resizable()
//                .scaledToFit()
//                .frame(width: width)
//                .padding(.bottom, 24)
//            
//            Text(desc)
//                .font(Font.custom("SF Pro", size: 15))
//                .multilineTextAlignment(.center)
//                .foregroundColor(Color(red: 0.54, green: 0.54, blue: 0.56))
//                .frame(width: 358)
//        }
//        .offset(y: -100)
//        .tag(tag)
//        .transition(transition)
//    }
// }

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
