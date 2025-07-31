//
//  RemoteImageView.swift
//  TemporaryDirectory
//
//  Created by nika razmadze on 01.08.25.
//

import SwiftUI

struct RemoteImageView: View {
    @State private var uiImage: UIImage?
    
    let url: URL
    private let cache = ImageCacheManager.shared
    
    var body: some View {
        Group {
            if let uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            } else {
                Rectangle()
                    .foregroundColor(.gray.opacity(0.3))
                    .overlay { ProgressView() }
            }
        }
        .task { await load() }
        .clipped()
    }
    
    private func load() async {
        if let cached = cache.image(for: url) {
            uiImage = cached
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let img = UIImage(data: data) {
                uiImage = img
                cache.store(data, for: url)
            }
        } catch {
        }
    }
}

