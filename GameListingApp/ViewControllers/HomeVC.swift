//
//  HomeViewController.swift
//  GameListingApp
//
//  Created by Yiğithan Sönmez on 31.12.2023.
//

import UIKit

class HomeVC: UIViewController {
    
    var games = [Game]()

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
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10)
        ]
        
        NSLayoutConstraint.activate(collectionViewConstraints)
    }
}

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return games.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UpcomingGameCollectionViewCell.identifier, for: indexPath) as! UpcomingGameCollectionViewCell
        
        if var imageURL = games[indexPath.item].cover?.url {
            imageURL.insert(contentsOf: "https:", at: imageURL.startIndex)
            imageURL = imageURL.replacingOccurrences(of: "t_thumb", with: "t_cover_big")
            print(imageURL)
            if let url = URL(string: imageURL){
                cell.configure(with: url)
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
