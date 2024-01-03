//
//  Game.swift
//  GameListingApp
//
//  Created by Yiğithan Sönmez on 1.01.2024.
//

import Foundation

struct Game: Codable {
    let id: Int?
    let cover: Cover?
    let firstReleaseDate: Int?
    let name: String?
    let platforms: [Int]?

    enum CodingKeys: String, CodingKey {
        case id
        case cover
        case firstReleaseDate = "first_release_date"
        case name
        case platforms
    }
}

struct Cover: Codable {
    let id: Int?
    let url: String?
}
