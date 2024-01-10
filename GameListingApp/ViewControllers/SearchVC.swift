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

    private let searchController = UISearchController(searchResultsController: SearchResultViewController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search Games"
        
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
    }
}

// MARK: - Search
extension SearchVC: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        self.searchTimer?.invalidate()
        
        guard let text = searchController.searchBar.text else {
            return
        }
        
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [weak self] (timer) in
            DispatchQueue.global(qos: .userInteractive).async { [weak self] in
              //Use search text and perform the query
              DispatchQueue.main.async {
                  NetworkManager.shared.searchGames(by: text) { result in
                      switch result{
                      case .success(let games):
                          let vc = searchController.searchResultsController as? SearchResultViewController
                          vc?.configure(with: games)
                      case .failure(let error):
                          print(error)
                      }
                  }
              }
            }
          })
        
//        print(text)
    }
}
