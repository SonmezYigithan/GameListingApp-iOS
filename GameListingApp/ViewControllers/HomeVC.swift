//
//  HomeViewController.swift
//  GameListingApp
//
//  Created by Yiğithan Sönmez on 31.12.2023.
//

import UIKit

final class HomeVC: UIViewController {
    
    private var games = [Game]()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UpcomingGameCollectionViewCell.self, forCellWithReuseIdentifier: UpcomingGameCollectionViewCell.identifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        applyConstraints()
        
        NetworkManager.shared.fetchUpcomingGames { result in
            switch result {
            case .success(let game):
                self.games.append(contentsOf: game)
                self.collectionView.reloadData()
            case.failure(let error):
                print(error)
            }
        }
    }
    
    func applyConstraints(){
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        let collectionViewConstraints = [
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10)
        ]
        
        NSLayoutConstraint.activate(collectionViewConstraints)
    }
}

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let gameDetailsVC = GameDetailsVC()
        gameDetailsVC.configure(with: games[indexPath.item])
        
        navigationController?.pushViewController(gameDetailsVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return games.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UpcomingGameCollectionViewCell.identifier, for: indexPath) as! UpcomingGameCollectionViewCell
        
        if var imageURL = games[indexPath.item].cover?.url {
            imageURL.insert(contentsOf: "https:", at: imageURL.startIndex)
            imageURL = imageURL.replacingOccurrences(of: "t_thumb", with: "t_cover_big")
            if let url = URL(string: imageURL){
                cell.configure(with: url)
                games[indexPath.item].cover?.formattedURL = url
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = CGSize(width: view.frame.width/3 - 20, height: 150)
        //        print(cellSize)
        return cellSize
    }
    
}
