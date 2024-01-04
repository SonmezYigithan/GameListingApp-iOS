//
//  Screenshots.swift
//  GameListingApp
//
//  Created by Yiğithan Sönmez on 4.01.2024.
//

import Foundation

struct Screenshot: Codable{
    let id: Int?
    let screenshots: [Screenshots]?
}

struct Screenshots: Codable{
    let id: Int?
    let url: String?
}
