//
//  APIKeys.swift
//  GameListingApp
//
//  Created by Yiğithan Sönmez on 2.01.2024.
//

import Foundation

class APIKeys {
    let dictionary: NSDictionary
    
    init(resourceName: String) {
        guard let filePath = Bundle.main.path(forResource: resourceName, ofType: "plist"),
                let plist = NSDictionary(contentsOfFile: filePath) else {
            fatalError("Could not find the file '\(resourceName)' plist. Please follow these steps to generate API Keys: https://github.com/SonmezYigithan/GameListingApp-iOS#create-api-keys")
        }
        dictionary = plist
        
        // Check if IGDB_CLIENT_ID or IGDB_AUTHORIZATION is nil or empty
        if let igdbClientId = dictionary["IGDB_CLIENT_ID"] as? String, igdbClientId.isEmpty {
            fatalError("IGDB_CLIENT_ID is empty. Please follow these steps to generate API Keys: https://github.com/SonmezYigithan/GameListingApp-iOS#create-api-keys")
        }
        if let igdbAuthorization = dictionary["IGDB_AUTHORIZATION"] as? String, igdbAuthorization.isEmpty {
            fatalError("IGDB_AUTHORIZATION is empty. Please follow these steps to generate API Keys: https://github.com/SonmezYigithan/GameListingApp-iOS#create-api-keys")
        }
    }
    
    var IGDBClientId: String {
        dictionary["IGDB_CLIENT_ID"] as? String ?? ""
    }
    
    var IGDBAuthorization: String {
        dictionary["IGDB_AUTHORIZATION"] as? String ?? ""
    }
}
