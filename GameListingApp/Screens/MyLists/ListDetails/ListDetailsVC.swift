//
//  ProfileVC.swift
//  GameListingApp
//
//  Created by Yiğithan Sönmez on 31.12.2023.
//

import UIKit

protocol ListDetailsVCProtocol: AnyObject {
    func reloadCollectionView()
}

final class ListDetailsVC: UIViewController {
    // MARK: - Properties
    private lazy var viewModel: ListDetailsVMProtocol = ListDetailsVM()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(CoverArtCollectionViewCell.self, forCellWithReuseIdentifier: CoverArtCollectionViewCell.identifier)
        return view
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.view = self
        prepareView()
    }
    
    func configure(with listEntity: ListEntity) {
        title = listEntity.name
        viewModel.configure(with: listEntity)
    }
    
    // TODO: Optimize
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchGames()
    }
    
    func prepareView() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        applyConstraints()
    }
    
    // MARK: - Constraints
    
    private func applyConstraints(){
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10)
        ])
    }
}

// MARK: - Collection View Protocols

extension ListDetailsVC: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.getFavouriteGamesCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CoverArtCollectionViewCell.identifier, for: indexPath) as! CoverArtCollectionViewCell
        
        let urlString = viewModel.getCoverArtURLString(of: indexPath.item)
        cell.configure(with: urlString)
        
        return cell
    }
}

extension ListDetailsVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return viewModel.getCellSize(viewWidth: view.frame.width)
    }
}

// MARK: - ListDetailsVCProtocol

extension ListDetailsVC: ListDetailsVCProtocol {
    func reloadCollectionView() {
        collectionView.reloadData()
    }
}
