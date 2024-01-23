//
//  GameDetailsViewModel.swift
//  GameListingApp
//
//  Created by Yiğithan Sönmez on 17.01.2024.
//

import Foundation
import UIKit

protocol GameDetailsVMProtocol {
    var view: GameDetailsProtocol? { get set }
    
    func favouriteButtonTapped()
    func videoThumbnailButtonTapped()
    func getScreenshotCount() -> Int
    func getFormattedScreenshotURL(of index: Int) -> String
    func calculateCellSize(using frameWidth: CGFloat) -> CGSize
    func fetchGameDetails(with gameId: Int)
}

class GameDetailsVM {
    internal weak var view: GameDetailsProtocol?
    internal var screenshots = [Screenshot]()
    
    var gameId: Int?
    var coverURL: String?
    var videoURL: String?
    
    func fetchScreenshots(of gameId: Int){
        ScreenshotManager.shared.fetchScreenshots(of: gameId) { [weak self] result in
            switch result {
            case .success(let screenshots):
                self?.screenshots.append(contentsOf: screenshots)
                self?.view?.reloadCollectionView()
                self?.decideCoverBackground()
            case.failure(let error):
                print(error)
            }
        }
    }
    
    func decideCoverBackground() {
        if screenshots.count > 0 {
            let screenshotURL = getFormattedScreenshotURL(of: 0)
            view?.configureCoverBackground(with: screenshotURL, isTranslucent: true)
        } else {
            if let coverURL = coverURL {
                view?.configureCoverBackground(with: coverURL, isTranslucent: true)
            }
        }
    }
}

extension GameDetailsVM: GameDetailsVMProtocol {
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
                
                var releaseDateString = ""
                if let releaseDateEpoch = game.firstReleaseDate {
                    let date = Date(timeIntervalSince1970: TimeInterval(releaseDateEpoch))
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "d MMMM yyyy"
                    dateFormatter.locale = Locale(identifier: "en_US")
                    
                    releaseDateString = dateFormatter.string(from: date)
                }
                
                var videoThumbnail: String? = nil
                if let gameVideoId = game.videos?.first?.video_id {
                    self?.videoURL = GameVideoManager.shared.getYoutubeUrl(with: gameVideoId)
                    
                    videoThumbnail = GameVideoManager.shared.getYoutubeThumbnailURL(with: gameVideoId)
                }
                
                let gameDetailsArguments = GameDetailsArguments(
                    coverURL: coverURL,
                    name: game.name ?? "",
                    description: game.summary ?? "",
                    developers: game.developer ?? [],
                    releaseDate: releaseDateString,
                    platforms: game.platforms ?? [],
                    videoThumbnail: videoThumbnail,
                    isFavourite: FavouriteGameManager.shared.checkIfGameIsFavourite(with: Int64(game.id))
                )
                
                self?.view?.configureGameDetailUIElements(with: gameDetailsArguments)
            case .failure(let error):
                print(error)
            }
        }
        
        fetchScreenshots(of: gameId)
        
    }
    
    func videoThumbnailButtonTapped() {
        guard let videoURL = videoURL else {
            return
        }
        
        if let url = URL(string: videoURL), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            print("Invalid URL or unable to open the URL")
        }
    }
}
