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
    // MARK: - Properties
    
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
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search Games"
        
        viewModel.view = self
        viewModel.viewDidLoad()
    }
    
    // MARK: - Constraints
    
    private func applyConstraints(){
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
}

// MARK: - UISearchResultsUpdating
extension SearchVC: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.updateSearchResults(for: searchController)
    }
}

// MARK: - SearchResultsVCDelegate
extension SearchVC: SearchResultsVCDelegate{
    func searchResultsViewControllerDidTapCellItem(_ gameId: Int) {
        viewModel.searchResultsViewControllerDidTapCellItem(gameId)
    }
}

// MARK: - SearchVCProtocol

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
