//
//  FavouriteGames+CoreDataProperties.swift
//  
//
//  Created by Yiğithan Sönmez on 11.01.2024.
//
//

import Foundation
import CoreData


extension FavouriteGame {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavouriteGame> {
        return NSFetchRequest<FavouriteGame>(entityName: "FavouriteGame")
    }

    @NSManaged public var gameId: Int64
    @NSManaged public var screenshotURL: String?

}
