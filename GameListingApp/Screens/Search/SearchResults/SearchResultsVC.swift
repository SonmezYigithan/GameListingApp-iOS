//
//  SearchResultViewController.swift
//  GameListingApp
//
//  Created by Yiğithan Sönmez on 9.01.2024.
//

import UIKit

protocol SearchResultsVCDelegate: AnyObject {
    func searchResultsViewControllerDidTapCellItem(_ gameId: Int)
}

protocol SearchResultsVCProtocol: AnyObject {
    func prepareSearchResultsTableView()
    func reloadResultsTableView()
    func showEmptyResultView()
    func hideEmptyResultView()
}

final class SearchResultsVC: UIViewController {
    private lazy var viewModel: SearchResultsVMProtocol = SearchResultsVM()
    
    public weak var delegate: SearchResultsVCDelegate?
    
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
        viewModel.view = self
        viewModel.viewDidLoad()
    }
    
    func configure(with games: [Game]){
        viewModel.configureSearchResults(with: games)
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

extension SearchResultsVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.getSearchResultCount()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.searchResultsViewControllerDidTapCellItem(viewModel.getSearchResultGameId(by: indexPath.item))
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchTabTableViewCell.identifier, for: indexPath) as! SearchTabTableViewCell
        cell.configure(with: viewModel.configureCell(with: indexPath.row))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        viewModel.getCellHeightForRow()
    }
}

extension SearchResultsVC: SearchResultsVCProtocol {
    func prepareSearchResultsTableView() {
        view.addSubview(searchResultsTableView)
        view.addSubview(searchEmptyResultView)
        searchResultsTableView.delegate = self
        searchResultsTableView.dataSource = self
        applyConstraints()
    }
    
    func reloadResultsTableView() {
        searchResultsTableView.reloadData()
    }
    
    func showEmptyResultView() {
        searchEmptyResultView.isHidden = false
    }
    
    func hideEmptyResultView() {
        searchEmptyResultView.isHidden = true
    }
}
