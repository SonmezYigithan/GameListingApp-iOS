//
//  ProfileVC.swift
//  GameListingApp
//
//  Created by Yiğithan Sönmez on 31.12.2023.
//

import UIKit

final class ProfileVC: UIViewController {
    
    private var favouriteGames = [FavouriteGame]()
    
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
        
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        applyConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFavourites()
    }
    
    private func getFavourites(){
        guard let favourites = FavouriteGameManager.shared.getFavouriteGames() else {
            return
        }
        
        self.favouriteGames = favourites
        collectionView.reloadData()
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
        return favouriteGames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CoverArtCollectionViewCell.identifier, for: indexPath) as! CoverArtCollectionViewCell
        
        guard let urlString = favouriteGames[indexPath.item].screenshotURL else {
            return cell
        }
        
        if let url = URL(string: urlString.convertIgdbPathToURLString(replaceOccurrencesOf: "t_thumb", replaceWith: "t_cover_big")) {
            cell.configure(with: url)
        }
        
        return cell
    }
}

extension ProfileVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = CGSize(width: view.frame.width/3 - 20, height: 150)
        //        print(cellSize)
        return cellSize
    }
}
