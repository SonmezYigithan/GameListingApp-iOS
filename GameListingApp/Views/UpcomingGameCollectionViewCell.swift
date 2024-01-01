//
//  GameCollectionViewCell.swift
//  GameListingApp
//
//  Created by Yiğithan Sönmez on 1.01.2024.
//

import UIKit

class UpcomingGameCollectionViewCell: UICollectionViewCell {
    static let identifier = "UpcomingGameCell"
    
    private let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        
        layer.cornerRadius = 20
        layer.masksToBounds = true
        
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with color:UIColor){
        backgroundColor = color
    }
    
    func applyConstraints(){
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let gameImageViewConstraints = [
            imageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(gameImageViewConstraints)
    }
}
