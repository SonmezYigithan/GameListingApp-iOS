//
//  HomeViewModel.swift
//  GameListingApp
//
//  Created by Yiğithan Sönmez on 16.01.2024.
//

import Foundation

protocol HomeVMProtocol {
    var view: HomeVCProtocol? { get set }
    var games: [Game] { get }
    
    func viewDidLoad()
    func fetchUpcomingGames()
    func didSelectItem(at indexPath: IndexPath)
    func getGamesCount() -> Int
    func getGame(at index: IndexPath.Index) -> Game
    func getCellSize(viewWidth: CGFloat) -> CGSize
    func getFormattedImageURL(from gameAtIndex: IndexPath.Index) -> String
}

final class HomeVM {
    internal weak var view: HomeVCProtocol?
    var games = [Game]()
    
    func fetchUpcomingGames() {
        GameDetailsManager.shared.fetchUpcomingGames { [weak self] result in
            switch result {
            case .success(let games):
                self?.games.append(contentsOf: games)
                self?.view?.refreshCollectionView()
            case.failure(let error):
                print(error)
            }
        }
    }
}

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
        let cellSize = CGSize(width: viewWidth/3 - 20, height: 150)
        return cellSize
    }
}
