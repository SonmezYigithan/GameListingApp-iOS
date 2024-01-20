//
//  SearchVC.swift
//  GameListingApp
//
//  Created by Yiğithan Sönmez on 31.12.2023.
//

import UIKit
import Combine

protocol SearchVCProtocol: AnyObject {
    func prepareSearchController()
    func navigateToGameDetails(with gameDetailsVC: GameDetailsVC)
}

final class SearchVC: UIViewController {
    private lazy var viewModel: SearchVMProtocol = SearchVM()
    
    private let searchController: UISearchController = {
        let searchResultVC = SearchResultsVC()
        let searchController = UISearchController(searchResultsController: searchResultVC)
        return searchController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search Games"
        
        viewModel.view = self
        viewModel.viewDidLoad()
    }
}

// MARK: - Search Results
extension SearchVC: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.updateSearchResults(for: searchController)
    }
}

// MARK: - Navigate to Game Details Screen
extension SearchVC: SearchResultsVCDelegate{
    func searchResultsViewControllerDidTapCellItem(_ gameId: Int) {
        viewModel.searchResultsViewControllerDidTapCellItem(gameId)
    }
}

extension SearchVC: SearchVCProtocol {
    func prepareSearchController() {
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = true;
        navigationItem.searchController = searchController
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func navigateToGameDetails(with gameDetailsVC: GameDetailsVC) {
        self.navigationController?.pushViewController(gameDetailsVC, animated: true)
    }
}
