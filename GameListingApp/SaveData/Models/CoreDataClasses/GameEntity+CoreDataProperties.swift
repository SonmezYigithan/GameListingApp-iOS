//
//  GameEntity+CoreDataProperties.swift
//  GameListingApp
//
//  Created by Yiğithan Sönmez on 27.01.2024.
//
//

import Foundation
import CoreData


extension GameEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GameEntity> {
        return NSFetchRequest<GameEntity>(entityName: "GameEntity")
    }

    @NSManaged public var gameId: Int64
    @NSManaged public var gameName: String?
    @NSManaged public var screenshotURL: String?
    @NSManaged public var list: [ListEntity]?

}

// MARK: Generated accessors for list
extension GameEntity {

    @objc(addListObject:)
    @NSManaged public func addToList(_ value: ListEntity)

    @objc(removeListObject:)
    @NSManaged public func removeFromList(_ value: ListEntity)

    @objc(addList:)
    @NSManaged public func addToList(_ values: NSSet)

    @objc(removeList:)
    @NSManaged public func removeFromList(_ values: NSSet)

}

extension GameEntity : Identifiable {

}
