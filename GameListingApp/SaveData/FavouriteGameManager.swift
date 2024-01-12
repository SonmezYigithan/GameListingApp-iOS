//
//  CoreDataManager.swift
//  GameListingApp
//
//  Created by Yiğithan Sönmez on 11.01.2024.
//

import UIKit

class FavouriteGameManager {
    static let shared = FavouriteGameManager()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func getFavouriteGames() -> [FavouriteGame]? {
        do {
            let favouriteGames = try context.fetch(FavouriteGame.fetchRequest())
            return favouriteGames
        }
        catch let error as NSError{
            print(error)
            return nil
        }
    }
    
    func addGameToFavourites(gameId: Int64, screenshotURL: String){
        let newGame = FavouriteGame(context: context)
        newGame.gameId = gameId
        newGame.screenshotURL = screenshotURL
        
        do {
            try context.save()
            print("Saved Data")
        }
        catch let error as NSError{
            print(error)
        }
    }
    
    func checkIfGameIsFavourite(with gameId: Int64) -> Bool{
        do {
            let fetchRequest = FavouriteGame.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "gameId == \(gameId)")
            let count = try context.count(for: fetchRequest)
            return count > 0
        }
        catch let error as NSError{
            print(error)
            return false
        }
    }
    
    func removeGameFromFavourites(game: FavouriteGame){
        context.delete(game)
        
        do {
            try context.save()
        }
        catch let error as NSError{
            print(error)
        }
    }
}
