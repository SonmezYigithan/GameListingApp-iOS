//
//  SearchVC.swift
//  GameListingApp
//
//  Created by Yiğithan Sönmez on 31.12.2023.
//

import UIKit
import Combine

final class SearchVC: UIViewController {
    
    var searchTimer: Timer?
    
    private let searchController: UISearchController = {
        let searchResultVC = SearchResultsViewController()
        let searchController = UISearchController(searchResultsController: searchResultVC)
        return searchController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search Games"
        
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = true;
        navigationItem.searchController = searchController
        navigationController?.navigationBar.prefersLargeTitles = false
    }
}

// MARK: - Search
extension SearchVC: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        self.searchTimer?.invalidate()
        
        guard let text = searchController.searchBar.text else {
            return
        }
        
        guard let resultsController = searchController.searchResultsController as? SearchResultsViewController else {
            return
        }
        
        resultsController.delegate = self
        
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (timer) in
            DispatchQueue.global(qos: .userInteractive).async {
                DispatchQueue.main.async {
                    NetworkManager.shared.searchGames(by: text) { result in
                        switch result{
                        case .success(let games):
                            resultsController.configure(with: games)
                        case .failure(let error):
                            print(error)
                        }
                    }
                }
            }
        })
    }
}

// MARK: - Navigate to Game Details Screen
extension SearchVC: SearchResultsViewControllerDelegate{
    func searchResultsViewControllerDidTapCellItem(_ gameId: Int) {
        NetworkManager.shared.searchSingleGame(by: gameId) { result in
            switch(result){
            case .success(let game):
                print("SUCCESS \(gameId)")
                let gameDetailsVC = GameDetailsVC()
                gameDetailsVC.configure(with: game[0])
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(gameDetailsVC, animated: true)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
