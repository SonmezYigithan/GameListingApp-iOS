//
//  HomeViewModel.swift
//  GameListingApp
//
//  Created by Yiğithan Sönmez on 16.01.2024.
//

import Foundation
import UIKit

protocol HomeVMProtocol {
    var view: HomeVCProtocol? { get set }
    var games: [Game] { get }
    
    func viewDidLoad()
    func fetchUpcomingGames()
    func paginateUpcomingGames()
    func didSelectItem(at indexPath: IndexPath)
    func getGamesCount() -> Int
    func getGame(at index: IndexPath.Index) -> Game
    func getCellSize(viewWidth: CGFloat) -> CGSize
    func getFormattedImageURL(from gameAtIndex: IndexPath.Index) -> String
}

final class HomeVM {
    // MARK: - Properties
    
    var isPaginating = false
    
    internal weak var view: HomeVCProtocol?
    var games = [Game]()
    
    func fetchUpcomingGames() {
        view?.showLoadingIndicator()
        GameDetailsManager.shared.fetchUpcomingGames { [weak self] result in
            switch result {
            case .success(let games):
                self?.games.append(contentsOf: games)
                self?.view?.refreshCollectionView()
                self?.view?.hideLoadingIndicator()
            case.failure(let error):
                print(error)
            }
        }
    }
    
    func paginateUpcomingGames() {
        if isPaginating {
            return
        }
        
        isPaginating = true
        let paginationOffset = games.count
        
        GameDetailsManager.shared.fetchUpcomingGamesWith(paginationOffset: paginationOffset) { [weak self] result in
            switch result {
            case .success(let games):
                self?.games.append(contentsOf: games)
                self?.view?.refreshCollectionView()
            case.failure(let error):
                print(error)
            }
            self?.isPaginating = false
        }
    }
}

// MARK: - HomeVMProtocol

extension HomeVM: HomeVMProtocol {
    func viewDidLoad() {
        fetchUpcomingGames()
        view?.prepareCollectionView()
    }
    
    func didSelectItem(at indexPath: IndexPath) {
        let gameDetailsVC = GameDetailsVC()
        gameDetailsVC.configure(with: games[indexPath.item].id)
        view?.navigateToGameDetails(with: gameDetailsVC)
    }
    
    func getGamesCount() -> Int {
        return games.count
    }
    
    func getGame(at index: IndexPath.Index) -> Game {
        return games[index]
    }
    
    func getFormattedImageURL(from gameAtIndex: IndexPath.Index) -> String{
        if var imageURL = games[gameAtIndex].cover?.url {
            imageURL = imageURL.convertIgdbPathToURLString(replaceOccurrencesOf: "t_thumb", replaceWith: "t_cover_big")
            return imageURL
        }
        return ""
    }
    
    func getCellSize(viewWidth: CGFloat) -> CGSize{
        if UIDevice.current.userInterfaceIdiom == .phone {
            let width = viewWidth/3 - 20
            let cellSize = CGSize(width: width, height: (width / 264) * 352)
            return cellSize
        }
        if UIDevice.current.userInterfaceIdiom == .pad {
            let width = viewWidth/3 - 20
            let cellSize = CGSize(width: width, height: (width / 264) * 352)
            return cellSize
        }
        
        let width = viewWidth/3 - 20
        let cellSize = CGSize(width: width, height: (width / 264) * 352)
        return cellSize
    }
}
