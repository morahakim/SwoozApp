//
//  EditableTextSheet.swift
//  ascenttt
//
//  Created by Auliya Michelle Adhana on 30/10/24.
//

import SwiftUI

struct EditableTextSheet: View {
    @Binding var isPresented: Bool
    @Binding var text: String
    let placeholder: String
    let maxCharacters: Int

    @State private var textCharacterCount = 0

    var body: some View {
        VStack {
            Spacer()
            VStack(alignment: .leading) {
                TextField(placeholder, text: $text)
                    .onChange(of: text) { newValue in
                        textCharacterCount = newValue.count
                        if newValue.count > maxCharacters {
                            text = String(newValue.prefix(maxCharacters))
                        }
                    }
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(.bottom, 8)

                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.black)
                Text("\(textCharacterCount)/\(maxCharacters)")
                    .font(.caption2)
            }
            .padding(.horizontal, 24)

            Spacer()

            Button {
                isPresented = false
            } label: {
                Text(buttonSaveText)
                    .font(Font.custom("SF Pro", size: 15))
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 14)
                    .frame(maxWidth: .infinity)
                    .background(Color(red: 0.13, green: 0.75, blue: 0.45))
                    .cornerRadius(12)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 8)
            .disabled(text.trimmingCharacters(in: .whitespaces).isEmpty)
        }.presentationDragIndicator(.visible)
            .presentationDetents([.fraction(0.25)])
            .onAppear {
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                    if let controller = windowScene.windows.first?.rootViewController {
                        if let presentedVC = controller.presentedViewController {
                            presentedVC.view.layer.cornerRadius = 28
                        }
                    }
                }
            }
    }
}

