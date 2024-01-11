//
//  SearchResultViewController.swift
//  GameListingApp
//
//  Created by Yiğithan Sönmez on 9.01.2024.
//

import UIKit

protocol SearchResultsViewControllerDelegate: AnyObject {
    func searchResultsViewControllerDidTapCellItem(_ gameId: Int)
}

final class SearchResultsViewController: UIViewController {
    private var searchResults = [Game]()
    
    public weak var delegate: SearchResultsViewControllerDelegate?
    
    private let searchResultsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(SearchTabTableViewCell.self, forCellReuseIdentifier: SearchTabTableViewCell.identifier)
        return tableView
    }()
    
    private let searchEmptyResultView: UIView = {
        let view = UIView()
        let label = UILabel()
        let image = UIImageView()
        
        label.text = "Oops! We couldn't find any games"
        image.image = UIImage(systemName: "multiply.circle")
        image.tintColor = .systemGray
        label.tintColor = .systemGray
        
        view.translatesAutoresizingMaskIntoConstraints = false
        image.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(image)
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: view.topAnchor),
            image.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            image.widthAnchor.constraint(equalToConstant: 50),
            image.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 15),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(searchResultsTableView)
        view.addSubview(searchEmptyResultView)
        searchResultsTableView.delegate = self
        searchResultsTableView.dataSource = self
        
        applyConstraints()
    }
    
    func configure(with games: [Game]){
        if(games.count > 0){
            searchEmptyResultView.isHidden = true
        }
        else{
            searchEmptyResultView.isHidden = false
        }
        
        searchResults = games
        searchResultsTableView.reloadData()
    }
    
    func applyConstraints(){
        NSLayoutConstraint.activate([
            searchResultsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchResultsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            searchResultsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            searchResultsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            searchEmptyResultView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchEmptyResultView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

extension SearchResultsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("SELECTED \(indexPath.item)")
        self.delegate?.searchResultsViewControllerDidTapCellItem(searchResults[indexPath.item].id)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchTabTableViewCell.identifier, for: indexPath) as! SearchTabTableViewCell
        cell.configure(with: searchResults[indexPath.item])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
