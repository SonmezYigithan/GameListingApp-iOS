//
//  ProfileVC.swift
//  GameListingApp
//
//  Created by Yiğithan Sönmez on 31.12.2023.
//

import UIKit

protocol ProfileVCProtocol: AnyObject {
    func prepareCollectionView()
    func reloadCollectionView()
}

final class ProfileVC: UIViewController {
    private lazy var viewModel: ProfileVMProtocol = ProfileVM()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(CoverArtCollectionViewCell.self, forCellWithReuseIdentifier: CoverArtCollectionViewCell.identifier)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Favourites"
        
        viewModel.view = self
        viewModel.viewDidLoad()
        
        applyConstraints()
    }
    
    // TODO: Optimize
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchFavourites()
    }
    
    private func applyConstraints(){
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}

extension ProfileVC: UICollectionViewDelegate, UICollectionViewDataSource{
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

extension ProfileVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        viewModel.getCellSize(viewWidth: view.frame.width)
    }
}

extension ProfileVC: ProfileVCProtocol {
    func prepareCollectionView() {
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func reloadCollectionView() {
        collectionView.reloadData()
    }
    
}
