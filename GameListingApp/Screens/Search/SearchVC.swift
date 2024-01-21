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
    func startSpinnerAnimation()
    func stopSpinnerAnimation()
}

final class SearchVC: UIViewController {
    private lazy var viewModel: SearchVMProtocol = SearchVM()
    
    private let searchController: UISearchController = {
        let searchResultVC = SearchResultsVC()
        let searchController = UISearchController(searchResultsController: searchResultVC)
        return searchController
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.style = .large
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search Games"
        
        viewModel.view = self
        viewModel.viewDidLoad()
    }
    
    private func applyConstraints(){
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
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
        view.addSubview(spinner)
        
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = true;
        navigationItem.searchController = searchController
        navigationController?.navigationBar.prefersLargeTitles = false
        
        applyConstraints()
    }
    
    func navigateToGameDetails(with gameDetailsVC: GameDetailsVC) {
        self.navigationController?.pushViewController(gameDetailsVC, animated: true)
    }
    
    func startSpinnerAnimation() {
        spinner.startAnimating()
    }
    
    func stopSpinnerAnimation() {
        spinner.stopAnimating()
    }
}
