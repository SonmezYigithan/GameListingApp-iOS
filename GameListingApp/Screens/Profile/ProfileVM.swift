//
//  ProfileVM.swift
//  GameListingApp
//
//  Created by Yiğithan Sönmez on 20.01.2024.
//

import Foundation

protocol ProfileVMProtocol {
    var view: ProfileVCProtocol? { get set }
    var favouriteGames: [FavouriteGame] { get }
    
    func viewDidLoad()
    func fetchFavourites()
    func getFavouriteGamesCount() -> Int
    func getCoverArtURLString(of index: Int) -> String
    func getCellSize(viewWidth: CGFloat) -> CGSize
}

class ProfileVM {
    weak var view: ProfileVCProtocol?
    var favouriteGames = [FavouriteGame]()
}

extension ProfileVM: ProfileVMProtocol {
    func viewDidLoad() {
        view?.prepareProfileVC()
    }
    
    func fetchFavourites() {
        guard let favourites = FavouriteGameManager.shared.getFavouriteGames() else {
            return
        }
        
        favouriteGames = favourites
        view?.reloadCollectionView()
    }
    
    func getFavouriteGamesCount() -> Int {
        favouriteGames.count
    }
    
    func getCoverArtURLString(of index: Int) -> String {
        if let urlString = favouriteGames[index].screenshotURL {
            return urlString
        }
        
        return ""
    }
    
    func getCellSize(viewWidth: CGFloat) -> CGSize {
        let cellSize = CGSize(width: viewWidth/3 - 20, height: 150)
        return cellSize
    }
    
    
}
