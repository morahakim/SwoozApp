//
//  TechniqueDetailView.swift
//  Swooz
//
//  Created by Agung Saputra on 27/10/23.
//

import SwiftUI

struct TechniqueDetailView: View {
    @State var showExplanationSheet = false
    @State var showRepetitionSheet = false
    @State var selectedRepetition = 0
    
    var body: some View {
        TechniqueDetailViewPotrait(
            showExplanationSheet: $showExplanationSheet,
            showRepetitionSheet: $showRepetitionSheet,
            selectedRepetition: $selectedRepetition
        )
        .onAppear {
            guard let windowScene = UIApplication
                .shared.connectedScenes.first as? UIWindowScene else { return }
            windowScene.requestGeometryUpdate(.iOS(
                interfaceOrientations: .portrait)
            )
        }
    }
}

private struct TechniqueDetailViewPotrait: View {
    @EnvironmentObject var vm: HomeViewModel
    @Environment(\.dismiss) private var dismiss
    
    @Binding var showExplanationSheet: Bool
    @Binding var showRepetitionSheet: Bool
    @Binding var selectedRepetition: Int
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.greenMain.ignoresSafeArea(.container, edges: .top)
            
            VStack {
                CardView(action: {}, content: {
                    VStack {
                        LottieView(name: "Low Serve")
                            .scaledToFill()
                    }.frame(height: 80)
//                        .resizable()
//                        .padding(.horizontal, 16)
//                        .padding(.top, 16)
                    HStack {
                        Spacer()
                        Text("Low Serve")
                            .font(Font.custom("Urbanist", size: 20).weight(.medium))
                            .foregroundColor(.neutralBlack)
                        Spacer()
                    }
                    .padding(.bottom, 16)
                })
                .padding(.bottom, 16)
                
                ZStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 390, height: 574)
                        .background(.white)
                        .clipShape(
                            .rect(
                                topLeadingRadius: 20,
                                bottomLeadingRadius: 0,
                                bottomTrailingRadius: 0,
                                topTrailingRadius: 20
                            )
                        )
                    VStack(spacing: 12) {
                        Text("Basic technique used to start a game.")
                            .font(Font.custom("SF Pro", size: 17))
                            .foregroundColor(.neutralBlack)
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                        
                        Button {
                            showExplanationSheet.toggle()
                        } label: {
                            VStack {
                                Text("Details")
                                    .font(Font.custom("SF Pro", size: 12))
                                    .foregroundColor(.information)
                                Image(systemName: "chevron.down")
                                    .foregroundStyle(.information)
                                    .scaledToFit()
                                    .frame(height: 14)
                            }
                        }
                        
                        TextAlignLeading("SWOOZ will provide visualizations of your shot strokes and shuttlecock targeting points, color-coded based on shot quality.")
                            .font(Font.custom("SF Pro", size: 15))
                            .foregroundColor(.grayStroke6)
                        
                        TextAlignLeading("Camera Placement Tutorial")
                            .font(Font.custom("SF Pro", size: 20))
                            .foregroundColor(.neutralBlack)
                        
                        TextAlignLeading("1. Prepare a 1.5-meter-high tripod for optimal performance. \n2. Place the tripod with your iPhone on the side of the court farthest from the service area. \n3. Align the camera guideline with the badminton court net. \n4. Set the Hit Counter as your recording limit or let it stop after 20 minutes automatically.")
                            .font(Font.custom("SF Pro", size: 15))
                            .foregroundColor(.grayStroke6)
                        
                        Rectangle()
                            .frame(width: 358, height: 173)
                            .cornerRadius(8)
                        
                        Spacer()
                    }
                    .padding(15)
                    
                }
            }
            .padding(.top, getSafeArea().top + 26)
            
            /** Button record */
            VStack {
                Spacer()
                VStack(alignment: .center) {
                    BtnPrimary(text: "Start Recording") {
                        showRepetitionSheet.toggle()
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .padding(.bottom, getSafeArea().bottom - 15)
                .background(.white)
                .clipShape(
                    .rect(
                        topLeadingRadius: 12,
                        bottomLeadingRadius: 0,
                        bottomTrailingRadius: 0,
                        topTrailingRadius: 12
                    )
                )
                .shadow(color: .black.opacity(0.08), radius: 2, x: 0, y: -2)
            }
            
            /** Navbar back */
            NavbarBack(action: {
                dismiss()
            }, bg: .greenMain)
        }
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $showExplanationSheet) {
            ExplanationSheet().presentationDetents([.medium])
        }
        .sheet(isPresented: $showRepetitionSheet) {
            RepetitionSheet(
                isPresented: $showRepetitionSheet,
                selectedRepetition: $selectedRepetition
            ).presentationDetents([.fraction(0.4)])
        }
    }
}

private struct RepetitionSheet: View {
    @EnvironmentObject var vm: HomeViewModel
    @Binding var isPresented: Bool
    @Binding var selectedRepetition: Int
    
    @AppStorage("hitTarget") var hitTarget: Int = 0
    
    var body: some View {
        VStack(alignment: .leading) {
            TextAlignLeading("Set Hit Counter")
                .font(Font.custom("SF Pro", size: 20).bold())
                .foregroundColor(.neutralBlack)
                .padding(.top, 18)
                .padding(.horizontal, 16)
            
            Picker("", selection: $selectedRepetition) {
                Text("Countless").tag(0)
                Text("5").tag(5)
                Text("10").tag(10)
                Text("20").tag(20)
                Text("30").tag(30)
                Text("40").tag(40)
                Text("50").tag(50)
                Text("60").tag(60)
                Text("70").tag(70)
                Text("80").tag(80)
            }
            .pickerStyle(.wheel)
            .padding(.horizontal, 16)
            
            Divider()
            BtnPrimary(text: "Continue") {
                hitTarget = selectedRepetition
                isPresented.toggle()
                vm.path.append(.RotateToLandscape)
            }
            .padding(.horizontal, 16)
        }
    }
}

private struct ExplanationSheet: View {
    var body: some View {
        VStack {
            TextAlignLeading("Details")
                .font(Font.custom("SF Pro", size: 20).bold())
                .foregroundColor(.neutralBlack)
                .padding(.bottom, 16)
            
            VStack(spacing: 8) {
                TextAlignLeading("What is Low Serve?")
                    .font(Font.custom("SF Pro", size: 20))
                    .foregroundColor(.neutralBlack)
                TextAlignLeading("Low serve in badminton is one of the basic techniques used to start a game. It is a type of serve performed by placing the badminton shuttle low and close to the net, allowing the shuttlecock to pass over the net only a few centimeters above it.")
                    .font(Font.custom("SF Pro", size: 15))
                    .foregroundStyle(.grayStroke6)
            }
            .padding(.bottom, 12)
            
            VStack(spacing: 8) {
                TextAlignLeading("Purpose")
                    .font(Font.custom("SF Pro", size: 20))
                    .foregroundColor(.neutralBlack)
                TextAlignLeading("The main purpose of the low serve is to prevent the opponent from easily attacking. This technique is typically used in situations where a player wants to initiate a game round or change the service during a game. The low serve requires special skills to avoid errors such as serving too high or too low and usually demands good control over the shuttlecock.")
                    .font(Font.custom("SF Pro", size: 15))
                    .foregroundStyle(.grayStroke6)
            }
            
            Spacer()
        }
        .padding(.vertical, 18)
        .padding(.horizontal, 16)
    }
}

#Preview {
    TechniqueDetailView()
}
