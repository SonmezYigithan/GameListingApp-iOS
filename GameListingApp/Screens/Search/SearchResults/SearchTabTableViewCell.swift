//
//  SearchTabTableViewCell.swift
//  GameListingApp
//
//  Created by Yiğithan Sönmez on 9.01.2024.
//

import UIKit
import Kingfisher

struct SearchTabTableViewCellArguments {
    let name: String
    let coverURL: String
}

final class SearchTabTableViewCell: UITableViewCell {
    // MARK: - Properties
    
    static let identifier = "SearchTabTableViewCell"
    
    private let coverImage: UIImageView = {
        let image = UIImageView()
        image.layer.borderWidth = 0.5
        image.layer.borderColor = UIColor.lightGray.cgColor
        image.layer.cornerRadius = 8
        image.layer.masksToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let gameNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Life Cycle
    
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
    
    func configure(with arguments: SearchTabTableViewCellArguments){
        gameNameLabel.text = arguments.name
        
        let imageURL = arguments.coverURL.convertIgdbPathToURLString(replaceOccurrencesOf: "t_thumb", replaceWith: "t_cover_big")
        if let url = URL(string: imageURL){
            coverImage.kf.setImage(with: url)
        }
    }
    
    // MARK: - Constraints
    
    func applyConstraints(){
        NSLayoutConstraint.activate([
            coverImage.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            coverImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            coverImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            coverImage.widthAnchor.constraint(equalToConstant: 88),
            coverImage.heightAnchor.constraint(equalToConstant: 118)
        ])
        
        NSLayoutConstraint.activate([
            gameNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            gameNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            gameNameLabel.leadingAnchor.constraint(equalTo: coverImage.trailingAnchor, constant: 10),
            gameNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
        ])
    }
}
