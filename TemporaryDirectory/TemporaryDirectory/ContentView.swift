//
//  ContentView.swift
//  TemporaryDirectory
//
//  Created by nika razmadze on 01.08.25.
//

import SwiftUI

struct ContentView: View {
    @State private var photos: [UnsplashPhoto] = []
    @State private var errorMsg: String?
    @ObservedObject private var cache = ImageCacheManager.shared
    
    private let columns = [GridItem(.adaptive(minimum: 120), spacing: 8)]
    
    var body: some View {
        NavigationView {
            ScrollView {
                if let errorMsg {
                    Text(errorMsg).foregroundColor(.red)
                }
                
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(photos) { photo in
                        if let url = URL(string: photo.urls.small) {
                            RemoteImageView(url: url)
                                .frame(height: 120)
                                .cornerRadius(8)
                        }
                    }
                }
                .padding(8)
            }
            .navigationTitle("Unsplash Cache")
            .toolbar {
                Button("Clear Cache") { cache.clearCache() }
            }
            .task { await loadPhotos() }
        }
    }
    
    private func loadPhotos() async {
        do {
            photos = try await UnsplashService.fetchPhotos()
        } catch {
            errorMsg = error.localizedDescription
        }
    }
}


//#Preview {
//    ContentView()
//}
