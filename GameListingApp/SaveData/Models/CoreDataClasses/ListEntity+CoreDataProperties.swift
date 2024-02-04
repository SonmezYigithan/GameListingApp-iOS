//
//  ListEntity+CoreDataProperties.swift
//  GameListingApp
//
//  Created by Yiğithan Sönmez on 27.01.2024.
//
//

import Foundation
import CoreData


extension ListEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ListEntity> {
        return NSFetchRequest<ListEntity>(entityName: "ListEntity")
    }

    @NSManaged public var name: String?
    @NSManaged public var listId: Int64
    @NSManaged public var games: NSOrderedSet?
    
    var gameEntities: [GameEntity]? {
        return games?.array as? [GameEntity]
    }
}

// MARK: Generated accessors for games
extension ListEntity {

    @objc(addGamesObject:)
    @NSManaged public func addToGames(_ value: GameEntity)

    @objc(removeGamesObject:)
    @NSManaged public func removeFromGames(_ value: GameEntity)

    @objc(addGames:)
    @NSManaged public func addToGames(_ values: NSSet)

    @objc(removeGames:)
    @NSManaged public func removeFromGames(_ values: NSSet)

}

extension ListEntity : Identifiable {

}
