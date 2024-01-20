//
//  SearchViewModel.swift
//  GameListingApp
//
//  Created by Yiğithan Sönmez on 20.01.2024.
//

import UIKit

protocol SearchVMProtocol {
    var view: SearchVCProtocol? { get set }
    
    func viewDidLoad()
    func searchResultsViewControllerDidTapCellItem(_ gameId: Int)
    func updateSearchResults(for searchController: UISearchController)
}

class SearchVM {
    internal weak var view: SearchVCProtocol?
    var searchTimer: Timer?
}

extension SearchVM: SearchVMProtocol {
    func viewDidLoad() {
        view?.prepareSearchController()
    }
    
    func searchResultsViewControllerDidTapCellItem(_ gameId: Int) {
        GameDetailsManager.shared.searchGame(by: gameId) { [weak self] result in
            switch(result){
            case .success(let game):
                let gameDetailsVC = GameDetailsVC()
                gameDetailsVC.configure(with: game.id)
                DispatchQueue.main.async {
                    self?.view?.navigateToGameDetails(with: gameDetailsVC)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        self.searchTimer?.invalidate()
        
        guard let text = searchController.searchBar.text else {
            return
        }
        
        guard let resultsController = searchController.searchResultsController as? SearchResultsVC else {
            return
        }
        
        resultsController.delegate = view as? any SearchResultsVCDelegate
        
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (timer) in
            DispatchQueue.global(qos: .userInteractive).async {
                DispatchQueue.main.async {
                    GameDetailsManager.shared.searchGames(by: text) { result in
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
