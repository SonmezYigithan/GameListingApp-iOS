//
//  SearchResultsViewModel.swift
//  GameListingApp
//
//  Created by Yiğithan Sönmez on 20.01.2024.
//

import Foundation

protocol SearchResultsVMProtocol {
    var view: SearchResultsVCProtocol? { get set }
    var games: [Game] { get }
    
    func viewDidLoad()
    func configureSearchResults(with searchResults: [Game])
    func getSearchResultGameId(by index: Int) -> Int
    func getSearchResultCount() -> Int
    func configureCell(with index: Int) -> SearchTabTableViewCellArguments
    func getCellHeightForRow() -> CGFloat
}

final class SearchResultsVM {
    // MARK: - Properties
    
    weak var view: SearchResultsVCProtocol?
    var games = [Game]()
}

// MARK: - SearchResultsVMProtocol

extension SearchResultsVM: SearchResultsVMProtocol {
    func viewDidLoad() {
        view?.prepareSearchResultsTableView()
    }
    
    func configureSearchResults(with searchResults: [Game]) {
        games = searchResults
        
        games.count > 0 ? view?.hideEmptyResultView() : view?.showEmptyResultView()
        
        view?.reloadResultsTableView()
    }
    
    func getSearchResultGameId(by index: Int) -> Int {
        games[index].id
    }
    
    func getSearchResultCount() -> Int {
        games.count
    }
    
    func configureCell(with index: Int) -> SearchTabTableViewCellArguments{
        let args = SearchTabTableViewCellArguments(
            name: games[index].name ?? "",
            coverURL: games[index].cover?.url ?? "")
        
        return args
    }
    
    func getCellHeightForRow() -> CGFloat {
        150
    }
}
