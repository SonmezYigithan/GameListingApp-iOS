//
//  ProfileVM.swift
//  GameListingApp
//
//  Created by Yiğithan Sönmez on 20.01.2024.
//

import Foundation

protocol ListDetailsVMProtocol {
    var view: ListDetailsVCProtocol? { get set }
    
    func fetchGames()
    func configure(with listEntity: ListEntity)
    func getFavouriteGamesCount() -> Int
    func getCoverArtURLString(of index: Int) -> String
    func getCellSize(viewWidth: CGFloat) -> CGSize
}

final class ListDetailsVM {
    weak var view: ListDetailsVCProtocol?
    var list: ListEntity?
}

extension ListDetailsVM: ListDetailsVMProtocol {
    
    func fetchGames() {
        
    }
    
    func configure(with listEntity: ListEntity) {
        list = listEntity
    }
    
    func getFavouriteGamesCount() -> Int {
        guard let games = list?.games?.count else { return 0 }
        return games
    }
    
    func getCoverArtURLString(of index: Int) -> String {
        if let urlString = list?.games?[index].screenshotURL {
            return urlString
        }
        
        return ""
    }
    
    func getCellSize(viewWidth: CGFloat) -> CGSize {
        let cellSize = CGSize(width: viewWidth/3 - 20, height: 150)
        return cellSize
    }
    
    
}
