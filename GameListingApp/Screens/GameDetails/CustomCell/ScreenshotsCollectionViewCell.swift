//
//  ScreenshotsCollectionViewCell.swift
//  GameListingApp
//
//  Created by Yiğithan Sönmez on 4.01.2024.
//

import UIKit

final class ScreenshotsCollectionViewCell: UICollectionViewCell {
    static let identifier = "ScreenshotsCollectionViewCell"
    
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        return image
    }()
    
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
    
    func configure(with imageUrl: String){
        if let url = URL(string: imageUrl) {
            imageView.kf.setImage(with: url)
        }
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
