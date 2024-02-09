//
//  GameNetworkManager.swift
//  GameListingApp
//
//  Created by Yiğithan Sönmez on 19.01.2024.
//

import Foundation

final class GameDetailsManager {
    static let shared = GameDetailsManager()
    
    func fetchUpcomingGames(completion: @escaping (Result<[Game],Error>)->()){
        let url = IGDBNetworkHelper.shared.baseURL + "games"
        
        let body: String = """
            fields name,id,first_release_date,platforms,cover.url,summary,platforms.name,involved_companies.company.name;
            where platforms = (167) & first_release_date > \(Int(NSDate().timeIntervalSince1970)) & (category = 0 | category = 9 | category = 8) & version_parent = null;
            sort first_release_date asc;
            limit 50;
        """
        
        NetworkManager.shared.request([Game].self, url: url, body: body, method: .post) { result in
            switch result{
            case.success(let game):
                completion(.success(game))
            case.failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchUpcomingGamesWith(paginationOffset: Int, completion: @escaping (Result<[Game],Error>) -> ()) {
        let url = IGDBNetworkHelper.shared.baseURL + "games"
        
        let body: String = """
            fields name,id,first_release_date,platforms,cover.url,summary,platforms.name,involved_companies.company.name;
            where platforms = (167) & first_release_date > \(Int(NSDate().timeIntervalSince1970)) & (category = 0 | category = 9 | category = 8) & version_parent = null;
            sort first_release_date asc;
            limit 50;
            offset \(paginationOffset);
        """
        
        NetworkManager.shared.request([Game].self, url: url, body: body, method: .post) { result in
            switch result{
            case.success(let game):
                completion(.success(game))
            case.failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func searchGames(by gameName: String, completion: @escaping (Result<[Game],Error>)->()) {
        let url = IGDBNetworkHelper.shared.baseURL + "games"
        
        let body: String = """
            search "\(gameName)";
            fields name,cover.url;
        """
        
        NetworkManager.shared.request([Game].self, url: url, body: body, method: .post) { result in
            switch result{
            case.success(let game):
                completion(.success(game))
            case.failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func searchGame(by gameId: Int, completion: @escaping (Result<Game,Error>)->()) {
        let url = IGDBNetworkHelper.shared.baseURL + "games"
        
        let body: String = """
            fields name,id,first_release_date,platforms,cover.url,summary,platforms.name,involved_companies.company.name,videos.video_id;
            where id = \(gameId);
            limit 1;
        """
        
        NetworkManager.shared.request([Game].self, url: url, body: body, method: .post) { result in
            switch result{
            case.success(let game):
                if let firstGame = game.first {
                    completion(.success(firstGame))
                } else{
                    print("Game Returned Nil")
                }
            case.failure(let error):
                completion(.failure(error))
            }
        }
    }
}
