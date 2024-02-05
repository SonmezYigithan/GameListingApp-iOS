//
//  NetworkHelper.swift
//  GameListingApp
//
//  Created by Yiğithan Sönmez on 19.01.2024.
//

import Alamofire

final class IGDBNetworkHelper {
    static let shared = IGDBNetworkHelper()
    
    private let apiKeys = APIKeys(resourceName: "API-Keys")
    
    let baseURL = "https://api.igdb.com/v4/"
    
    func headers() -> HTTPHeaders{
        ["Client-ID": apiKeys.IGDBClientId,
         "Authorization": apiKeys.IGDBAuthorization,
         "Accept": "application/json"
        ]
    }
}
