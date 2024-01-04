//
//  NetworkManager.swift
//  GameListingApp
//
//  Created by Yiğithan Sönmez on 2.01.2024.
//

import Foundation
import Alamofire

class NetworkManager{
    static let shared = NetworkManager()
    
    let igdbEndpoint = "https://api.igdb.com/v4"
    
    func fetchUpcomingGames(completion: @escaping (Result<[Game], Error>) -> Void){
        let url = igdbEndpoint + "/games"
        
        let igdbHeaders : HTTPHeaders = [
            "Client-ID":APIKeys.IGDBClientId,
            "Authorization":APIKeys.IGDBAuthorization,
            "Accept":"application/json"
        ]
        
        let body: String = """
            fields name,id,first_release_date,platforms,cover.url,summary,platforms.name,involved_companies.company.name;
            where platforms = (167) & first_release_date > \(Int(NSDate().timeIntervalSince1970));
            sort first_release_date asc;
            limit 50;
        """
        
        AF.request(url, method: .post, encoding: body, headers: igdbHeaders)
//            .response(completionHandler: { results in
//                if let data = results.data, let utf8Text = String(data: data, encoding: .utf8) {
//                        print("Data: \(utf8Text)")
//                }
//            })
            .validate()
            .responseDecodable(of: [Game].self) { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func fetchScreenshots(of game: String, completion: @escaping (Result<[Screenshot], Error>) -> Void){
        let url = igdbEndpoint + "/games"
        
        let igdbHeaders : HTTPHeaders = [
            "Client-ID":APIKeys.IGDBClientId,
            "Authorization":APIKeys.IGDBAuthorization,
            "Accept":"application/json"
        ]
        
        let body: String = """
            fields screenshots.url;
            search "\(game)";
            limit 1;
        """
        
        AF.request(url, method: .post, encoding: body, headers: igdbHeaders)
            .response(completionHandler: { results in
                if let data = results.data, let utf8Text = String(data: data, encoding: .utf8) {
                        print("Data: \(utf8Text)")
                }
            })
            .validate()
            .responseDecodable(of: [Screenshot].self) { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}

extension String: ParameterEncoding {
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }
}