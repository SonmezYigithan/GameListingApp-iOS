//
//  ScreenshotManager.swift
//  GameListingApp
//
//  Created by Yiğithan Sönmez on 19.01.2024.
//

import Foundation

final class ScreenshotManager {
    static let shared = ScreenshotManager()
    
    func fetchScreenshots(of gameId: Int, completion: @escaping (Result<[Screenshot],Error>)->()){
        let url = IGDBNetworkHelper.shared.baseURL + "games"
        
        let body: String = """
            fields screenshots.url;
            where id = \(gameId);
            limit 1;
        """
        
        NetworkManager.shared.request([Screenshot].self, url: url, body: body, method: .post) { result in
            switch result{
            case.success(let game):
                completion(.success(game))
            case.failure(let error):
                completion(.failure(error))
            }
        }
    }
}
