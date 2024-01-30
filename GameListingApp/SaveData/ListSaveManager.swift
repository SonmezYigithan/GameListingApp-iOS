//
//  CoreDataManager.swift
//  GameListingApp
//
//  Created by Yiğithan Sönmez on 11.01.2024.
//

import UIKit

class ListSaveManager {
    static let shared = ListSaveManager()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func addGameToList(gameId: Int, screenshotURL: String?, listName: String) {
        if let gameEntity = getGame(gameId: gameId) {
            addGameWithGameEntity(gameEntity: gameEntity, to: listName)
        }
        else {
            let gameEntity = GameEntity(context: context)
            gameEntity.gameId = Int64(gameId)
            gameEntity.screenshotURL = screenshotURL
            
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
                print("Saved Data")
            }
        }
        catch let error as NSError{
            print(error)
        }
    }
    
    func createList(name: String) {
        let listEntity = ListEntity(context: context)
        listEntity.name = name
        
        do {
            try context.save()
            print("Saved Data")
        }
        catch let error as NSError{
            print(error)
        }
    }
    
    func getGamesFromList(with listName: String) -> [GameEntity]? {
        do {
            let predicate = NSPredicate(format: "name == %@", listName)
            let fetchRequest = ListEntity.fetchRequest()
            fetchRequest.predicate = predicate
            
            let gameList = try context.fetch(fetchRequest)
            print(gameList.count)
            if let gameList = gameList.first {
                print(gameList.name!)
            }
            return nil
        }
        catch let error as NSError {
            print(error)
            return nil
        }
    }
    
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
    
    func getListsofGameAddedTo(gameId: Int) -> [ListEntity]? {
        guard let game = getGame(gameId: gameId) else {
            print("Game Could Not Found with Game Id")
            return nil
        }
        
        return game.list
    }
    
    // Burada gamein içindeki listlerin referansını falan tutmak yerine
    // gameId ile game al ama game'in içindeki
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
    
    //    func getFavouriteGames() -> [FavouriteGame]? {
    //        do {
    //            let favouriteGames = try context.fetch(FavouriteGame.fetchRequest())
    //            return favouriteGames
    //        }
    //        catch let error as NSError{
    //            print(error)
    //            return nil
    //        }
    //    }
    //
    //    func addGameToFavourites(gameId: Int64, screenshotURL: String) {
    //        let newGame = FavouriteGame(context: context)
    //        newGame.gameId = gameId
    //        newGame.screenshotURL = screenshotURL
    //
    //        do {
    //            try context.save()
    //            print("Saved Data")
    //        }
    //        catch let error as NSError{
    //            print(error)
    //        }
    //    }
    //
    //    func checkIfGameIsFavourite(with gameId: Int64) -> Bool {
    //        do {
    //            let fetchRequest = FavouriteGame.fetchRequest()
    //            fetchRequest.predicate = NSPredicate(format: "gameId == \(gameId)")
    //            let count = try context.count(for: fetchRequest)
    //            return count > 0
    //        }
    //        catch let error as NSError{
    //            print(error)
    //            return false
    //        }
    //    }
    //
    //    func removeGameFromFavourites(game: FavouriteGame) {
    //        context.delete(game)
    //
    //        do {
    //            try context.save()
    //        }
    //        catch let error as NSError{
    //            print(error)
    //        }
    //    }
}
