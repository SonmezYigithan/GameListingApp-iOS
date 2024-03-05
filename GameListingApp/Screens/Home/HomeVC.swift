//
//  HomeViewController.swift
//  GameListingApp
//
//  Created by Yiğithan Sönmez on 31.12.2023.
//

import UIKit

protocol HomeVCProtocol: AnyObject {
    func refreshCollectionView()
    func navigateToGameDetails(with gameDetailsVC: GameDetailsVC)
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func showNetworkErrorView()
    func hideNetworkErrorView()
}

final class HomeVC: UIViewController {
    // MARK: - Properties
    private lazy var viewModel: HomeVMProtocol = HomeVM()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CoverArtCollectionViewCell.self, forCellWithReuseIdentifier: CoverArtCollectionViewCell.identifier)
        return collectionView
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.isHidden = true
        view.style = .large
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let networkErrorView: NetworkErrorView = {
        let view = NetworkErrorView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Upcoming Games"
        
        networkErrorView.delegate = self
        
        viewModel.view = self
        viewModel.viewDidLoad()
        
        prepareView()
    }
    
    private func prepareView() {
        view.addSubview(collectionView)
        view.addSubview(loadingIndicator)
        view.addSubview(networkErrorView)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        applyConstraints()
    }
    
    // MARK: - Constraints
    
    func applyConstraints(){
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            loadingIndicator.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            loadingIndicator.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            loadingIndicator.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            loadingIndicator.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            networkErrorView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            networkErrorView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            networkErrorView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            networkErrorView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
}

// MARK: - CollectionView Protocols

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectItem(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getGamesCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CoverArtCollectionViewCell.identifier, for: indexPath) as! CoverArtCollectionViewCell
        
        let imageURL = viewModel.getFormattedImageURL(from: indexPath.item)
        cell.configure(with: imageURL)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return viewModel.getCellSize(viewWidth: view.frame.width)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == viewModel.getGamesCount() - 9{
            viewModel.paginateUpcomingGames()
        }
    }
}

// MARK: - HomeVCProtocol

extension HomeVC: HomeVCProtocol {
    func refreshCollectionView() {
        collectionView.reloadData()
    }
    
    func navigateToGameDetails(with gameDetailsVC: GameDetailsVC) {
        navigationController?.pushViewController(gameDetailsVC, animated: true)
    }
    
    func showLoadingIndicator() {
        loadingIndicator.startAnimating()
        collectionView.isHidden = true
    }
    
    func hideLoadingIndicator() {
        loadingIndicator.stopAnimating()
        collectionView.isHidden = false
    }
    
    func showNetworkErrorView() {
        collectionView.isHidden = true
        networkErrorView.isHidden = false
    }
    
    func hideNetworkErrorView() {
        collectionView.isHidden = false
        networkErrorView.isHidden = true
    }
}

extension HomeVC: NetworkErrorViewDelegate {
    func retryNetworkRequest() {
        viewModel.fetchUpcomingGames()
    }
}
