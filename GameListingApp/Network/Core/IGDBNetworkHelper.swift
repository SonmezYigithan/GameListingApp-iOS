//
//  NetworkHelper.swift
//  GameListingApp
//
//  Created by Yiğithan Sönmez on 19.01.2024.
//

import Alamofire

class IGDBNetworkHelper {
    static let shared = IGDBNetworkHelper()
    
    let baseURL = "https://api.igdb.com/v4/"
    
    func headers() -> HTTPHeaders{
        ["Client-ID": APIKeys.IGDBClientId,
         "Authorization": APIKeys.IGDBAuthorization,
         "Accept": "application/json"
        ]
    }
    
    func checkHeaderDetails() {
        
    }
}
