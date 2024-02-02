//
//  MyListsTableViewCell.swift
//  GameListingApp
//
//  Created by Yiğithan Sönmez on 31.01.2024.
//

import UIKit

final class MyListsTableViewCell: UITableViewCell {
    // MARK: Typealias
    
    typealias Cell = GameCoverListCardCollectionViewCell
    
    // MARK: - Properties
    
    static let identifier = "MyListsTableViewCell"
    
    private var screenshotURLs: [String]?
    
    private let listName: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let numberOfGames: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(Cell.self, forCellWithReuseIdentifier: Cell.identifier)
        return collectionView
    }()
    
    // MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepareView()
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(listName: String, gameCount: String, gameScreenshotURLs: [String]) {
        self.listName.text = listName
        self.numberOfGames.text = "\(gameCount) games"
        screenshotURLs = gameScreenshotURLs
    }
    
    func prepareView() {
        addSubview(listName)
        addSubview(numberOfGames)
        addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    // MARK: - Constraints
    
    func applyConstraints() {
        NSLayoutConstraint.activate([
            listName.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            listName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            listName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            listName.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -10),
            listName.centerYAnchor.constraint(equalTo: numberOfGames.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            numberOfGames.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            numberOfGames.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -10),
            numberOfGames.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            numberOfGames.centerYAnchor.constraint(equalTo: listName.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: listName.bottomAnchor, constant: 5),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
}

extension MyListsTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let screenshotCount = screenshotURLs?.count else { return 0 }
        return screenshotCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.identifier , for: indexPath) as? Cell else { return UICollectionViewCell() }
        
        if screenshotURLs?.count == 0 { return cell }
        guard let screenshotURL = screenshotURLs?[indexPath.section] else { return cell }
        
        cell.configure(with: screenshotURL)
        
//        if indexPath.section == 0 {
//            cell.configure(with: "1234", color: .systemRed)
//        }
//        else if indexPath.section == 1 {
//            cell.configure(with: "1234", color: .systemBlue)
//        }
//        else if indexPath.section == 2 {
//            cell.configure(with: "1234", color: .systemYellow)
//        }
//        else if indexPath.section == 3 {
//            cell.configure(with: "1234", color: .systemGreen)
//        }
//        else if indexPath.section == 4 {
//            cell.configure(with: "1234", color: .systemCyan)
//        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 88, height: 118)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section > 0 {
            return UIEdgeInsets(top: -20, left: -30, bottom: 0, right: 0);
        }
        return UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0);
    }
}
