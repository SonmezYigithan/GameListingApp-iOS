//
//  ProfileVM.swift
//  GameListingApp
//
//  Created by Yiğithan Sönmez on 20.01.2024.
//

import Foundation

protocol ListDetailsVMProtocol {
    var view: ListDetailsVCProtocol? { get set }
    
    func configure(with listEntity: ListEntity)
    func getGamesCount() -> Int
    func getCoverArtURLString(of index: Int) -> String
    func getCellSize(viewWidth: CGFloat) -> CGSize
    func didSelectItem(at index: Int)
    func editListButtonTapped()
}

final class ListDetailsVM {
    // MARK: - Properties
    
    weak var view: ListDetailsVCProtocol?
    var list: ListEntity?
}

// MARK: - ListDetailsVMProtocol

extension ListDetailsVM: ListDetailsVMProtocol {
    func configure(with listEntity: ListEntity) {
        list = listEntity
    }
    
    func getGamesCount() -> Int {
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
    
    func didSelectItem(at index: Int) {
        guard let gameId = list?.games?[index].gameId else { return }
        let gameDetailsVC = GameDetailsVC()
        gameDetailsVC.configure(with: Int(gameId))
        view?.navigateToGameDetails(vc: gameDetailsVC)
    }
    
    func editListButtonTapped() {
        let vc = EditListVC()
        guard let list = list else { return }
        vc.configure(listEntity: list)
        view?.presentEditListView(vc: vc)
    }
}
