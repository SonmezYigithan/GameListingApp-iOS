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
        let stack = UIStackView()
        
        label.text = "Oops! We couldn't find any games"
        label.textAlignment = .center
        label.tintColor = .systemGray

        image.image = UIImage(systemName: "multiply.circle")
        image.tintColor = .systemGray
        image.contentMode = .scaleAspectFit
                
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 0

        view.translatesAutoresizingMaskIntoConstraints = false
        stack.translatesAutoresizingMaskIntoConstraints = false
        image.translatesAutoresizingMaskIntoConstraints = false
        
        stack.addArrangedSubview(image)
        stack.addArrangedSubview(label)
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            image.widthAnchor.constraint(equalToConstant: 80),
            image.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
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
            searchEmptyResultView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            searchEmptyResultView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            searchEmptyResultView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            searchEmptyResultView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
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
