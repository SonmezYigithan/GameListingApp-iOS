//
//  Game.swift
//  GameListingApp
//
//  Created by Yiğithan Sönmez on 1.01.2024.
//

import Foundation

struct Game: Codable {
    let id: Int
    var cover: Cover?
    let summary: String?
    let developer: [Developer]?
    let firstReleaseDate: Int?
    let name: String?
    let platforms: [Platform]?
    let videos: [Video]?

    enum CodingKeys: String, CodingKey {
        case id
        case cover
        case summary
        case firstReleaseDate = "first_release_date"
        case developer = "involved_companies"
        case name
        case platforms
        case videos
    }
}

struct Cover: Codable {
    let id: Int?
    let url: String?
    var formattedURL: URL?
}

struct Developer: Codable{
    let id: Int
    let company: Company?
}

struct Company: Codable{
    let id: Int
    let name: String?
}

struct Platform: Codable{
    let id: Int
    let name: String
}

struct Video: Codable {
    let id: Int
    let video_id: String?
}
