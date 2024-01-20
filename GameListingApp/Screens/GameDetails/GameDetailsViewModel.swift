//
//  GameDetailsViewModel.swift
//  GameListingApp
//
//  Created by Yiğithan Sönmez on 17.01.2024.
//

import Foundation

protocol GameDetailsViewModelProtocol {
    var view: GameDetailsProtocol? { get set }
//    var screenshots: [Screenshot] { get }
    
    func favouriteButtonTapped()
    func getScreenshotCount() -> Int
    func getFormattedScreenshotURL(of index: Int) -> String
    func calculateCellSize(using frameWidth: CGFloat) -> CGSize
    func fetchGameDetails(with gameId: Int)
    
}

class GameDetailsViewModel {
    internal weak var view: GameDetailsProtocol?
    internal var screenshots = [Screenshot]()
    
    var gameId: Int?
    var coverURL: String?
    
    func fetchScreenshots(of gameId: Int){
        ScreenshotManager.shared.fetchScreenshots(of: gameId) { result in
            switch result {
            case .success(let screenshots):
                self.screenshots.append(contentsOf: screenshots)
                self.view?.reloadCollectionView()
            case.failure(let error):
                print(error)
            }
        }
    }
}

extension GameDetailsViewModel: GameDetailsViewModelProtocol {
    func favouriteButtonTapped() {
        guard let gameId = gameId else { return }
        
        guard let coverURL = coverURL else { return }
        
        FavouriteGameManager.shared.addGameToFavourites(gameId: Int64(gameId), screenshotURL: coverURL)
    }
    
    func getScreenshotCount() -> Int {
        if let screenshotsCount = screenshots.first?.screenshots {
            return screenshotsCount.count
        }
        
        return 0
    }
    
    func getFormattedScreenshotURL(of index: Int) -> String {
        if let screenshotURLs = screenshots.first?.screenshots{
            if let screenshotURL = screenshotURLs[index].url{
                return screenshotURL.convertIgdbPathToURLString(replaceOccurrencesOf: "t_thumb", replaceWith: "t_screenshot_med")
            }
        }
        
        return ""
    }
    
    func calculateCellSize(using frameWidth: CGFloat) -> CGSize {
        let cellSize = CGSize(width: frameWidth - 75, height: 200)
        return cellSize
    }
    
    func fetchGameDetails(with gameId: Int) {
        self.gameId = gameId
        
        GameDetailsManager.shared.searchGame(by: gameId) { [weak self] result in
            switch result {
            case.success(let game):
                var coverURL = ""
                if let originalURL = game.cover?.url {
                    coverURL = originalURL.convertIgdbPathToURLString(replaceOccurrencesOf: "t_thumb", replaceWith: "t_cover_big")
                    self?.coverURL = coverURL
                }
                
                let gameDetailsArguments = GameDetailsArguments(
                    coverURL: coverURL,
                    name: game.name ?? "",
                    description: game.summary ?? "",
                    developers: game.developer ?? []
                )
                
                self?.view?.configureGameDetailUIElements(with: gameDetailsArguments)
            case .failure(let error):
                print(error)
            }
        }
        
        fetchScreenshots(of: gameId)
    }
}
