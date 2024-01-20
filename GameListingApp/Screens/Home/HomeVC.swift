//
//  HomeViewController.swift
//  GameListingApp
//
//  Created by Yiğithan Sönmez on 31.12.2023.
//

import UIKit

protocol HomeViewProtocol: AnyObject {
    func refreshCollectionView()
    func prepareCollectionView()
    func navigateToGameDetails(with gameDetailsVC: GameDetailsVC)
}

final class HomeVC: UIViewController {
    private lazy var viewModel: HomeViewModelProtocol = HomeViewModel()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CoverArtCollectionViewCell.self, forCellWithReuseIdentifier: CoverArtCollectionViewCell.identifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        viewModel.view = self
        viewModel.viewDidLoad()
    }
    
    func applyConstraints(){
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10)
        ])
    }
}

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
}

extension HomeVC: HomeViewProtocol {
    func prepareCollectionView(){
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        applyConstraints()
    }
    
    func refreshCollectionView() {
        collectionView.reloadData()
    }
    
    func navigateToGameDetails(with gameDetailsVC: GameDetailsVC) {
        navigationController?.pushViewController(gameDetailsVC, animated: true)
    }
}
