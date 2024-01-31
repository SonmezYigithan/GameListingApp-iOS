//
//  MyListsTableViewCell.swift
//  GameListingApp
//
//  Created by Yiğithan Sönmez on 31.01.2024.
//

import UIKit

class MyListsTableViewCell: UITableViewCell {
    static let identifier = "MyListsTableViewCell"
    
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepareView()
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(listName: String, gameCount: String) {
        self.listName.text = listName
        self.numberOfGames.text = "\(gameCount) games"
    }
    
    func prepareView() {
        addSubview(listName)
        addSubview(numberOfGames)
    }
    
    func applyConstraints() {
        NSLayoutConstraint.activate([
            listName.topAnchor.constraint(equalTo: topAnchor),
            listName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            listName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            listName.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            numberOfGames.topAnchor.constraint(equalTo: topAnchor),
            numberOfGames.bottomAnchor.constraint(equalTo: bottomAnchor),
//            numberOfGames.leadingAnchor.constraint(equalTo: listName.trailingAnchor),
            numberOfGames.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
    }
}
