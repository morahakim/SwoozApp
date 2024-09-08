//
//  GifView.swift
//  GifView_SwiftUI
//
//  Created by Pedro Rojas on 16/08/21.
//

import SwiftUI
import WebKit

struct GifImage: UIViewRepresentable {
    private let name: String

    init(_ name: String) {
        self.name = name
    }

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        guard let url = Bundle.main.url(forResource: name, withExtension: "gif") else {
            print("Error: GIF file not found")
            return webView
        }

        do {
            let data = try Data(contentsOf: url)
            webView.load(
                data,
                mimeType: "image/gif",
                characterEncodingName: "UTF-8",
                baseURL: url.deletingLastPathComponent()
            )
        } catch {
            print("Error loading GIF: \(error)")
        }

        webView.scrollView.isScrollEnabled = false
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.reload()
    }
}



struct GifImage_Previews: PreviewProvider {
    static var previews: some View {
        GifImage("pokeball")
    }
}
