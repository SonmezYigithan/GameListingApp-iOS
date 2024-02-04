//
//  EditListTableViewCell.swift
//  GameListingApp
//
//  Created by Yiğithan Sönmez on 3.02.2024.
//

import UIKit
import Kingfisher

class EditListTableViewCell: UITableViewCell {
    // MARK: - Properties
    static let identifier = "EditListTableViewCell"
    
    private let gameNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let coverImage: UIImageView = {
        let image = UIImageView()
        image.layer.borderWidth = 0.5
        image.layer.borderColor = UIColor.lightGray.cgColor
        image.layer.cornerRadius = 8
        image.layer.masksToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    // MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepareView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepareView() {
        addSubview(gameNameLabel)
        addSubview(coverImage)
        
        applyConstraints()
    }
    
    func configure(gameEntity: GameEntity?) {
        guard let game = gameEntity else { return }
        
        gameNameLabel.text = game.gameName
        
        if let url = URL(string: game.screenshotURL ?? "") {
            coverImage.kf.setImage(with: url)
        }
    }
    
    // MARK: - COnstraints
    
    func applyConstraints() {
        NSLayoutConstraint.activate([
            coverImage.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            coverImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 55),
            coverImage.widthAnchor.constraint(equalToConstant: 88),
            coverImage.heightAnchor.constraint(equalToConstant: 118)
        ])
        
        NSLayoutConstraint.activate([
            gameNameLabel.topAnchor.constraint(equalTo: topAnchor),
            gameNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            gameNameLabel.leadingAnchor.constraint(equalTo: coverImage.trailingAnchor, constant: 20),
            gameNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}
