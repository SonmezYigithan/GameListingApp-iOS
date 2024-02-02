//
//  GameCoverListCardCollectionViewCell.swift
//  GameListingApp
//
//  Created by Yiğithan Sönmez on 2.02.2024.
//

import UIKit
import Kingfisher

final class GameCoverListCardCollectionViewCell: UICollectionViewCell {
    static let identifier = "GameCoverListCardCollectionViewCell"
    
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.layer.borderWidth = 0.5
        image.layer.borderColor = UIColor.lightGray.cgColor
        image.layer.cornerRadius = 8
        image.layer.masksToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    func configure(with imageURL: String) {
        if let url = URL(string: imageURL) {
            imageView.kf.setImage(with: url)
        }
    }
    
    func applyConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
}
