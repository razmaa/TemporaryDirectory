//
//  UnsplashService.swift
//  TemporaryDirectory
//
//  Created by nika razmadze on 01.08.25.
//

import Foundation

struct UnsplashPhoto: Decodable, Identifiable {
    let id: String
    let urls: Urls
    struct Urls: Decodable { let small: String }
}

enum UnsplashService {
    
    static func fetchPhotos(page: Int = 1, perPage: Int = 30) async throws -> [UnsplashPhoto] {
        var comps = URLComponents(string: "https://api.unsplash.com/photos")!
        comps.queryItems = [
            .init(name: "page", value: "\(page)"),
            .init(name: "per_page", value: "\(perPage)")
        ]
        var req = URLRequest(url: comps.url!)
        req.setValue("Client-ID \(Secrets.unsplashKey)", forHTTPHeaderField: "Authorization")
        
        let (data, resp) = try await URLSession.shared.data(for: req)
        guard (resp as? HTTPURLResponse)?.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode([UnsplashPhoto].self, from: data)
    }
}
