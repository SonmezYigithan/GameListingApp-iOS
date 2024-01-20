//
//  NetworkManager.swift
//  GameListingApp
//
//  Created by Yiğithan Sönmez on 2.01.2024.
//

import Foundation
import Alamofire

final class APIManager: GameService {
//    static let shared = APIManager()
    
//    let igdbEndpoint = "https://api.igdb.com/v4"
    
//    let igdbHeaders : HTTPHeaders = [
//        "Client-ID":APIKeys.IGDBClientId,
//        "Authorization":APIKeys.IGDBAuthorization,
//        "Accept":"application/json"
//    ]
    
    func fetchUpcomingGames(completion: @escaping (Result<[Game], Error>) -> Void){
//        let url = NetworkHelper.shared.baseURL + "/games"
        
        let body: String = """
            fields name,id,first_release_date,platforms,cover.url,summary,platforms.name,involved_companies.company.name;
            where platforms = (167) & first_release_date > \(Int(NSDate().timeIntervalSince1970)) & (category = 0 | category = 9 | category = 8);
            sort first_release_date asc;
            limit 50;
        """
        
        
        
//        AF.request(url, method: .post, encoding: body, headers: igdbHeaders)
//            .validate()
//            .responseDecodable(of: [Game].self) { response in
//                switch response.result {
//                case .success(let data):
//                    completion(.success(data))
//                case .failure(let error):
//                    completion(.failure(error))
//                }
//            }
    }
    
    func fetchScreenshots(of gameId: Int, completion: @escaping (Result<[Screenshot], Error>) -> Void){
//        let url = NetworkHelper.shared.baseURL + "/games"
        
        let body: String = """
            fields screenshots.url;
            where id = \(gameId);
            limit 1;
        """
        
//        AF.request(url, method: .post, encoding: body, headers: NetworkHelper.shared.headers())
////            .response(completionHandler: { results in
////                if let data = results.data, let utf8Text = String(data: data, encoding: .utf8) {
////                        print("Data: \(utf8Text)")
////                }
////            })
//            .validate()
//            .responseDecodable(of: [Screenshot].self) { response in
//                switch response.result {
//                case .success(let data):
//                    completion(.success(data))
//                case .failure(let error):
//                    completion(.failure(error))
//                }
//            }
    }
    
    func searchGames(by gameName: String, completion: @escaping (Result<[Game], Error>) -> Void){
//        let url = igdbEndpoint + "/games"
        
        let body: String = """
            search "\(gameName)";
            fields name,cover.url;
        """
        
//        AF.request(url, method: .post, encoding: body, headers: igdbHeaders)
////            .response(completionHandler: { results in
////                if let data = results.data, let utf8Text = String(data: data, encoding: .utf8) {
////                        print("Data: \(utf8Text)")
////                }
////            })
//            .validate()
//            .responseDecodable(of: [Game].self) { response in
//                switch response.result {
//                case .success(let data):
//                    completion(.success(data))
//                case .failure(let error):
//                    completion(.failure(error))
//                }
//            }
    }
    
    func searchSingleGame(by gameId: Int, completion: @escaping (Result<[Game], Error>) -> Void){
//        let url = igdbEndpoint + "/games"
        
//        let body: String = """
//            fields name,id,first_release_date,platforms,cover.url,summary,platforms.name,involved_companies.company.name;
//            where id = \(gameId);
//            limit 1;
//        """
//        
//        AF.request(url, method: .post, encoding: body, headers: igdbHeaders)
////            .response(completionHandler: { results in
////                if let data = results.data, let utf8Text = String(data: data, encoding: .utf8) {
////                        print("Data: \(utf8Text)")
////                }
////            })
//            .validate()
//            .responseDecodable(of: [Game].self) { response in
//                switch response.result {
//                case .success(let data):
//                    completion(.success(data))
//                case .failure(let error):
//                    completion(.failure(error))
//                }
//            }
    }
}
