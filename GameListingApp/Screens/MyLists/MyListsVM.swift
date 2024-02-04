//
//  ProfileVM.swift
//  GameListingApp
//
//  Created by Yiğithan Sönmez on 20.01.2024.
//

import Foundation

protocol MyListsVMProtocol {
    var view: MyListsVCProtocol? { get set }
    
    func fetchLists()
    func addListButtonTapped()
    func getListsCount() -> Int
    func getListName(by index: Int) -> String
    func getNumberOfGamesInList(by listIndex: Int) -> Int
    func getScreenshotURLs(by listIndex: Int) -> [String]
    func didSelectRow(at index: Int)
    func deleteList(at index: Int) -> Bool
}

final class MyListsVM {
    // MARK: - Properties
    
    weak var view: MyListsVCProtocol?
    var lists = [ListEntity]()
}

extension MyListsVM: MyListsVMProtocol {
    func fetchLists() {
        guard let lists = ListSaveManager.shared.getAllLists() else { return }
        self.lists = lists
        view?.reloadTableView()
    }
    
    func addListButtonTapped() {
        let vc = CreateListVC()
        view?.presentCreateListView(vc: vc)
    }
    
    func getListsCount() -> Int {
        lists.count
    }
    
    func getListName(by index: Int) -> String {
        guard let listName = lists[index].name else { return "" }
        return listName
    }
    
    func getNumberOfGamesInList(by listIndex: Int) -> Int {
        guard let gameCount = lists[listIndex].games?.count else { return 0 }
        return gameCount
    }
    
    func getScreenshotURLs(by listIndex: Int) -> [String] {
        var screenshotURLs = [String]()
        
        if lists.count == 0 { return [] }
        let list = lists[listIndex]
        
        guard let games = list.games else { return [] }
        if games.count == 0 { return [] }
        
        for i in 0...4 {
            if games.indices.contains(i) {
                guard let screenshot = games[i].screenshotURL else { continue }
                screenshotURLs.append(screenshot)
            }
        }
        
        return screenshotURLs
    }
    
    func didSelectRow(at index: Int) {
        let vc = ListDetailsVC()
        vc.configure(with: lists[index])
        view?.navigateToListDetailsView(vc: vc)
    }
    
    func deleteList(at index: Int) -> Bool {
        guard let listName = lists[index].name else { return false }
        ListSaveManager.shared.deleteList(listName: listName)
        lists.remove(at: index)
        return true
    }
}
