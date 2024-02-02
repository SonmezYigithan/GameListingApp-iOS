//
//  GameCollectionViewCell.swift
//  GameListingApp
//
//  Created by Yiğithan Sönmez on 1.01.2024.
//

import UIKit
import Kingfisher

final class CoverArtCollectionViewCell: UICollectionViewCell {
    static let identifier = "CoverArtCollectionViewCell"
    
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
        
        layer.cornerRadius = 8
        layer.masksToBounds = true
        
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with imageUrl:String){
        backgroundColor = .red
        if let url = URL(string: imageUrl){
            imageView.kf.setImage(with: url)
        }
    }
    
    private func applyConstraints(){
        let gameImageViewConstraints = [
            imageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(gameImageViewConstraints)
    }
}
