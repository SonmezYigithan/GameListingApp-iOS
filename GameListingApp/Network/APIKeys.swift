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
            fatalError("Could not find the file '\(resourceName)' plist")
        }
        dictionary = plist
    }
    
    var IGDBClientId: String {
        dictionary.object(forKey: "IGDB_CLIENT_ID") as? String ?? ""
    }
    
    var IGDBAuthorization: String {
        dictionary.object(forKey: "IGDB_AUTHORIZATION") as? String ?? ""
    }
}
