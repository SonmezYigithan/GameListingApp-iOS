//
//  ScreenshotsCollectionViewCell.swift
//  GameListingApp
//
//  Created by Yiğithan Sönmez on 4.01.2024.
//

import UIKit

class ScreenshotsCollectionViewCell: UICollectionViewCell {
    static let identifier = "ScreenshotsCollectionViewCell"
    
    private let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        
        imageView.contentMode = .scaleAspectFill
        layer.cornerRadius = 20
        layer.masksToBounds = true
        
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with imageUrl:URL){
        imageView.kf.setImage(with: imageUrl)
    }
    
    func applyConstraints(){
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
