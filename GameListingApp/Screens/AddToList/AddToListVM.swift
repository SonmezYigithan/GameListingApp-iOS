//
//  AddToListVM.swift
//  GameListingApp
//
//  Created by Yiğithan Sönmez on 27.01.2024.
//

import Foundation

protocol AddToListVMProtocol {
    var view: AddToListVCProtocol? { get set }
    
    func getListCount() -> Int
    func getListName(by index: Int) -> String
    func didSelectList(at index: Int)
    func didUnselectList(at index: Int)
    func configureGameEntity(gameId: Int, screenshotURL: String?)
    func addGameToSelectedList()
    func createListButtonClicked()
    func canCellClickable(at index: Int) -> Bool
}

struct GameSaveDetails {
    let gameId: Int
    let screenshotURL: String?
}

final class AddToListVM {
    internal weak var view: AddToListVCProtocol?
    
    var lists = [ListEntity]()
    var unselectableLists: [ListEntity]?
    var gameSaveDetails: GameSaveDetails?
    var selectedIndex = [Int]()
    
    private func fetchAllLists() {
        guard let lists = ListSaveManager.shared.getAllLists() else { return }
        self.lists = lists
        
        getUnselectableLists()
    }
    
    private func getUnselectableLists() {
        guard let gameId = gameSaveDetails?.gameId else { return }
        
        guard let listEntity = ListSaveManager.shared.getListsofGameAddedTo(gameId: gameId) else { return }
        unselectableLists = listEntity
    }
    
    func canCellClickable(at index: Int) -> Bool {
        guard let gameId = gameSaveDetails?.gameId else { return false }
        guard let gameEntity = ListSaveManager.shared.getGame(gameId: gameId) else { return true }
        guard let gameLists = gameEntity.list else { return true }
        return !gameLists.contains { $0.name == lists[index].name }
    }
    
}

extension AddToListVM: AddToListVMProtocol {
    func configureGameEntity(gameId: Int, screenshotURL: String?) {
        let gameEntity = GameSaveDetails(gameId: gameId, screenshotURL: screenshotURL)
        gameSaveDetails = gameEntity
        fetchAllLists()
    }
    
    func getListCount() -> Int {
        return lists.count
    }
    
    func getListName(by index: Int) -> String {
        if let listName = lists[index].name {
            return listName
        }
        
        return ""
    }
    
    func didSelectList(at index: Int) {
        selectedIndex.append(index)
    }
    
    func didUnselectList(at index: Int) {
        let index = selectedIndex.firstIndex(of: index)
        guard let index = index else { return }
        selectedIndex.remove(at: index)
    }
    
    func addGameToSelectedList() {
        guard let gameSaveDetails = gameSaveDetails else {
            print("Game Details Empty")
            return
        }
        
        for index in selectedIndex {
            if let listName = lists[index].name {
                ListSaveManager.shared.addGameToList(gameId: gameSaveDetails.gameId, screenshotURL: gameSaveDetails.screenshotURL, listName: listName)
            }
        }

        view?.dismissView()
    }
    
    func createListButtonClicked() {
        let vc = CreateListVC()
        view?.presentCreateListView(vc: vc)
    }
    
}
