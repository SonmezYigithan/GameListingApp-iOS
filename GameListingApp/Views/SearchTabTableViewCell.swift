//
//  SearchTabTableViewCell.swift
//  GameListingApp
//
//  Created by Yiğithan Sönmez on 9.01.2024.
//

import UIKit
import Kingfisher

class SearchTabTableViewCell: UITableViewCell {
    
    static let identifier = "SearchTabTableViewCell"
    
    private let coverImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 20
        image.layer.masksToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let gameNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(gameNameLabel)
        addSubview(coverImage)
        selectionStyle = .none
        applyConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
    
    func configure(with game:Game){
        gameNameLabel.text = game.name
        
        if var imageURL = game.cover?.url {
            imageURL.insert(contentsOf: "https:", at: imageURL.startIndex)
            imageURL = imageURL.replacingOccurrences(of: "t_thumb", with: "t_cover_big")
            if let url = URL(string: imageURL){
                coverImage.kf.setImage(with: url)
            }
        }
    }
    
    func applyConstraints(){
        NSLayoutConstraint.activate([
            coverImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            coverImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 10),
            coverImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            coverImage.widthAnchor.constraint(equalToConstant: 125),
            coverImage.heightAnchor.constraint(equalToConstant: 125)
        ])
        
        NSLayoutConstraint.activate([
            gameNameLabel.leadingAnchor.constraint(equalTo: coverImage.trailingAnchor, constant: 10),
            gameNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            gameNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 10),
            gameNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 10),
        ])
    }
}
