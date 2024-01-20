//
//  NetworkManager.swift
//  GameListingApp
//
//  Created by Yiğithan Sönmez on 19.01.2024.
//

import Alamofire

class NetworkManager {
    static let shared = NetworkManager()
    
    func request<T: Codable>(_ type: T.Type, url: String, body: String, method: HTTPMethod, completion: @escaping((Result<T,Error>)->())){
        AF.request(url, method: .post, encoding: body, headers: IGDBNetworkHelper.shared.headers())
            .validate()
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
//            .response(completionHandler: { results in
//                if let data = results.data, let utf8Text = String(data: data, encoding: .utf8) {
//                    print("Data: \(utf8Text)")
//                }
//            })
    }
}
