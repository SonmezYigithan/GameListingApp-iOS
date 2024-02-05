//
//  CoreDataManager.swift
//  GameListingApp
//
//  Created by Yiğithan Sönmez on 11.01.2024.
//

import UIKit

final class ListSaveManager {
    static let shared = ListSaveManager()
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // MARK: - List Operations
    
    func getAllLists() -> [ListEntity]? {
        do {
            let lists = try context.fetch(ListEntity.fetchRequest())
            return lists
        }
        catch let error as NSError {
            print(error)
            return nil
        }
    }
    
    func createList(name: String) {
        let listEntity = ListEntity(context: context)
        listEntity.name = name
        
        do {
            try context.save()
            print("CoreData: Created new List")
        }
        catch let error as NSError{
            print(error)
        }
    }
    
    func deleteList(listName: String) {
        let predicate = NSPredicate(format: "name == %@", listName)
        let fetchRequest = ListEntity.fetchRequest()
        fetchRequest.predicate = predicate
        
        do {
            let list = try context.fetch(fetchRequest)
            if let firstList = list.first, list.count > 0 {
                context.delete(firstList)
                try context.save()
                print("CoreData: Deleted the list \(listName)")
            }
        }
        catch let error as NSError {
            print(error)
        }
    }
    
    func addGameToList(listName: String, gameSaveDetails: GameSaveDetails) {
        if let gameEntity = getGame(gameId: gameSaveDetails.gameId) {
            addGameWithGameEntity(gameEntity: gameEntity, to: listName)
        }
        else {
            let gameEntity = GameEntity(context: context)
            gameEntity.gameId = Int64(gameSaveDetails.gameId)
            gameEntity.gameName = gameSaveDetails.gameName
            gameEntity.screenshotURL = gameSaveDetails.screenshotURL
            
            addGameWithGameEntity(gameEntity: gameEntity, to: listName)
        }
    }
    
    private func addGameWithGameEntity(gameEntity: GameEntity, to ListName: String) {
        let predicate = NSPredicate(format: "name == %@", ListName)
        let fetchRequest = ListEntity.fetchRequest()
        fetchRequest.predicate = predicate
        
        do {
            let list = try context.fetch(fetchRequest)
            if let firstList = list.first, list.count > 0 {
                firstList.addToGames(gameEntity)
                try context.save()
                print("CoreData: Game added to the list \(ListName)")
            }
        }
        catch let error as NSError{
            print(error)
        }
    }
    
    func changeListName(list: ListEntity, to listName: String) {
        list.name = listName
        
        do {
            try context.save()
        } catch let error as NSError {
            print(error)
        }
    }
    
    // MARK: - Game Operations
    
    func getGame(gameId: Int) -> GameEntity? {
        do {
            let predicate = NSPredicate(format: "gameId == %ld", gameId)
            let fetchRequest = GameEntity.fetchRequest()
            fetchRequest.predicate = predicate
            
            let games = try context.fetch(fetchRequest)
            if let game = games.first {
                return game
            }
            return nil
        }
        catch let error as NSError {
            print(error)
            return nil
        }
    }
    
    func removeGame(game: GameEntity, from list: ListEntity) {
        list.removeFromGames(game)
        
        // check if game have any other lists
        if game.list?.count == 0 || game.list == nil {
            deleteGame(game: game)
        }
        
        do {
            try context.save()
            print("CoreData: Game deleted from the list \(list.name ?? "")")
        } catch let error as NSError {
            print(error)
        }
    }
    
    func deleteGame(game: GameEntity) {
        do {
            context.delete(game)
            try context.save()
        } catch let error as NSError {
            print(error)
        }
    }
    
    /// returns array of ListEntity where game with an gameId added to
    func getListsofGameAddedTo(gameId: Int) -> [ListEntity]? {
        guard let game = getGame(gameId: gameId) else {
            print("CoreData: Game Could Not Found with Game Id")
            return nil
        }
        
        return game.list
    }
    
    /// changes game position in list
    func moveGame(list: ListEntity, from sourceIndex: Int, to destinationIndex: Int) {
        guard let games = list.games?.mutableCopy() as? NSMutableOrderedSet else { return }
        
        games.exchangeObject(at: sourceIndex, withObjectAt: destinationIndex)
        
        list.games = games.copy() as? NSOrderedSet
        
        do {
            try context.save()
        } catch let error as NSError {
            print(error)
        }
    }
}
