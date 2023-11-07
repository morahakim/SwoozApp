//
//  Thumbnail.swift
//  Swooz
//
//  Created by Agung Saputra on 31/10/23.
//

import SwiftUI
import AVKit

struct VideoThumbnailView: View {
    var url: URL?
    @State private var thumbnailImage: UIImage?

    func getThumbnailImageFromVideoUrl(url: URL) {
        DispatchQueue.global(qos: .background).async {
            let asset = AVAsset(url: url)
            let avAssetImageGenerator = AVAssetImageGenerator(asset: asset)
            avAssetImageGenerator.appliesPreferredTrackTransform = true
            let thumbnailTime = CMTimeMake(value: 2, timescale: 1)
            do {
                let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumbnailTime, actualTime: nil)
                let thumbImage = UIImage(cgImage: cgThumbImage)
                DispatchQueue.main.async {
                    self.thumbnailImage = thumbImage
                }
            } catch {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    self.thumbnailImage = nil
                }
            }
        }
    }

    var body: some View {
        VStack {
            if let thumbnailImage = thumbnailImage {
                Image(uiImage: thumbnailImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                Text("Loading thumbnail...")
            }
        }
        .onAppear {
            if let url = url {
                getThumbnailImageFromVideoUrl(url: url)
            }
        }
    }
}

