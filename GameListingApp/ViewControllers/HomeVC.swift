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
        
        games.append(Game(name: "Uncharted 4", developer: "Naughty Dog"))
        games.append(Game(name: "The Last of Us", developer: "Santa Monica Studios"))
        games.append(Game(name: "Uncharted 4", developer: "Naughty Dog"))
        games.append(Game(name: "Uncharted 4", developer: "Naughty Dog"))
        games.append(Game(name: "Uncharted 4", developer: "Naughty Dog"))
        games.append(Game(name: "Uncharted 4", developer: "Naughty Dog"))
        games.append(Game(name: "Uncharted 4", developer: "Naughty Dog"))
        games.append(Game(name: "Uncharted 4", developer: "Naughty Dog"))
        games.append(Game(name: "Uncharted 4", developer: "Naughty Dog"))
        games.append(Game(name: "Uncharted 4", developer: "Naughty Dog"))
        games.append(Game(name: "Uncharted 4", developer: "Naughty Dog"))
        games.append(Game(name: "Uncharted 4", developer: "Naughty Dog"))
        games.append(Game(name: "Uncharted 4", developer: "Naughty Dog"))
        games.append(Game(name: "Uncharted 4", developer: "Naughty Dog"))
        games.append(Game(name: "Uncharted 4", developer: "Naughty Dog"))
        games.append(Game(name: "Uncharted 4", developer: "Naughty Dog"))
        games.append(Game(name: "Uncharted 4", developer: "Naughty Dog"))
        games.append(Game(name: "Uncharted 4", developer: "Naughty Dog"))

        
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        applyConstraints()
        
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
        cell.configure(with: .systemRed)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = CGSize(width: view.frame.width/3 - 20, height: 150)
        print(cellSize)
        return cellSize
    }
    
}
