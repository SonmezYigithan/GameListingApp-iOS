//
//  GameVideoManager.swift
//  GameListingApp
//
//  Created by Yiğithan Sönmez on 24.01.2024.
//

import Foundation

class GameVideoManager {
    static let shared = GameVideoManager()
    
    func getYoutubeUrl(with youtubeVideoId: String) -> String {
        "https://www.youtube.com/embed/\(youtubeVideoId)"
    }
    
    func getYoutubeThumbnailURL(with youtubeVideoId: String) -> String {
        "https://img.youtube.com/vi/\(youtubeVideoId)/sddefault.jpg"
    }
}
