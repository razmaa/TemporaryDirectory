//
//  ImageCacheManager.swift
//  TemporaryDirectory
//
//  Created by nika razmadze on 01.08.25.
//

import UIKit

final class ImageCacheManager: ObservableObject {
    
    static let shared = ImageCacheManager()
    private init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(clearCache),
            name: UIApplication.didReceiveMemoryWarningNotification,
            object: nil
        )
    }
    
    private let fm = FileManager.default
    private lazy var cacheURL: URL = URL(fileURLWithPath: NSTemporaryDirectory(),
                                         isDirectory: true)
        .appendingPathComponent("UnsplashCache", isDirectory: true)
    
    // MARK: Public API
    
    func image(for url: URL) -> UIImage? {
        if let diskData = try? Data(contentsOf: fileURL(for: url)) {
            return UIImage(data: diskData)
        }
        return nil
    }
    
    func store(_ data: Data, for url: URL) {
        createFolderIfNeeded()
        try? data.write(to: fileURL(for: url), options: .atomic)
    }
    
    @objc func clearCache() {
        try? fm.removeItem(at: cacheURL)
    }
    
    // MARK: Helpers
    
    private func fileURL(for url: URL) -> URL {
        cacheURL.appendingPathComponent(url.lastPathComponent)
    }
    
    private func createFolderIfNeeded() {
        guard !fm.fileExists(atPath: cacheURL.path) else { return }
        try? fm.createDirectory(at: cacheURL, withIntermediateDirectories: true)
    }
}

