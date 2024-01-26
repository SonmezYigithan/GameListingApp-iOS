//
//  GameDetailsViewModel.swift
//  GameListingApp
//
//  Created by Yiğithan Sönmez on 17.01.2024.
//

import Foundation
import UIKit
import SafariServices

protocol GameDetailsVMProtocol {
    var view: GameDetailsProtocol? { get set }
    
    func favouriteButtonTapped()
    func videoThumbnailButtonTapped()
    func fetchGameDetails(with gameId: Int)
}

class GameDetailsVM {
    internal weak var view: GameDetailsProtocol?
    internal var screenshots = [Screenshot]()
    internal var platforms = [Platform]()
    
    var gameId: Int?
    var coverURL: String?
    var videoURL: String?
    
    func fetchScreenshots(of gameId: Int){
        ScreenshotManager.shared.fetchScreenshots(of: gameId) { [weak self] result in
            switch result {
            case .success(let data):
                let screenshotUIModel = data
                            .compactMap { $0.screenshots }
                            .flatMap { $0 }
                            .compactMap { $0.url }
                            .map { self?.formatScreenshotURL($0) ?? "" }
                            .compactMap { ScreenshotUIModel(url: $0) }
                
                self?.screenshots.append(contentsOf: data)
                self?.view?.configureScreenshotCollectionView(with: screenshotUIModel)
                self?.decideCoverBackground()
            case.failure(let error):
                print(error)
            }
        }
    }
    
    func decideCoverBackground() {
        if screenshots.count > 0 {
            // TODO: Fix here
            let screenshotURL = formatScreenshotURL(screenshots[0].screenshots?[0].url ?? "")
            view?.configureCoverBackground(with: screenshotURL, isTranslucent: true)
        } else {
            if let coverURL = coverURL {
                view?.configureCoverBackground(with: coverURL, isTranslucent: true)
            }
        }
    }
    
    func formatScreenshotURL(_ screenshotURL: String) -> String {
        return screenshotURL.convertIgdbPathToURLString(replaceOccurrencesOf: "t_thumb", replaceWith: "t_screenshot_med")
    }
}

extension GameDetailsVM: GameDetailsVMProtocol {
    func favouriteButtonTapped() {
        guard let gameId = gameId else { return }
        
        guard let coverURL = coverURL else { return }
        
        FavouriteGameManager.shared.addGameToFavourites(gameId: Int64(gameId), screenshotURL: coverURL)
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
                
                if let platforms = game.platforms {
                    let platformUIModel = platforms
                        .compactMap { PlatformsUIModel(name: $0.name) }
                    
                    self?.view?.configurePlatformsCollectionView(with: platformUIModel)
                    
                    self?.platforms = platforms
                }
                
                let gameDetailsArguments = GameDetailsArguments(
                    coverURL: coverURL,
                    name: game.name ?? "",
                    description: game.summary ?? "",
                    developers: game.developer ?? [],
                    releaseDate: releaseDateString,
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
        
        if let url = URL(string: videoURL) {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            
            let vc = SFSafariViewController(url: url, configuration: config)
            view?.presentSFSafariView(vc: vc)
        }
    }
}
