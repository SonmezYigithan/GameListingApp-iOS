//
//  EditListVM.swift
//  GameListingApp
//
//  Created by Yiğithan Sönmez on 3.02.2024.
//

import UIKit

protocol EditListVMProtocol {
    var view: EditListVCProtocol? { get set }
    var listEntity: ListEntity? { get set }
    
    func saveButtonTapped()
    func getGameCount() -> Int
    func getGame(at index: Int) -> GameEntity?
    func deleteGame(at index: Int)
    func moveCell(from sourceIndex: Int, to destinationIndex: Int)
}

final class EditListVM {
    weak var view: EditListVCProtocol?
    weak var listEntity: ListEntity?
    
}

extension EditListVM: EditListVMProtocol {
    func saveButtonTapped() {
        
        view?.dismissView()
    }
    
    func getGameCount() -> Int {
        guard let count = listEntity?.games?.count else { return 0}
        return count
    }
    
    func getGame(at index: Int) -> GameEntity? {
        guard let games = listEntity?.games else { return nil }

        if games.indices.contains(index) {
            return games[index]
        }
        
        return nil
    }
    
    func deleteGame(at index: Int) {
        guard let listEntity = listEntity else { return }
        guard let gameEntity = listEntity.games?[index] else { return }
        ListSaveManager.shared.deleteGame(game: gameEntity, from: listEntity)
    }
    
    func moveCell(from sourceIndex: Int, to destinationIndex: Int) {
        guard let listEntity = listEntity else { return }
        ListSaveManager.shared.moveGame(list: listEntity, from: sourceIndex, to: destinationIndex)
    }
    
}
