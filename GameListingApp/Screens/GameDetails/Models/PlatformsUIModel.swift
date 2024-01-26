//
//  PlatformsUIModel.swift
//  GameListingApp
//
//  Created by Yiğithan Sönmez on 26.01.2024.
//

import Foundation

struct PlatformsUIModel {
    let name: String
    
    var shortenedName: String {
        if name == "PC (Microsoft Windows)" {
            return "PC"
        }
        return name
    }
}
