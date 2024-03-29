//
//  PlatformCollectionViewCell.swift
//  GameListingApp
//
//  Created by Yiğithan Sönmez on 24.01.2024.
//

import UIKit

final class PlatformCollectionViewCell: UICollectionViewCell {
    static let identifier = "PlatformCollectionViewCell"
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 17.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .tintColor
        layer.cornerRadius = 8
        
        addSubview(label)
        applyConstraints()
    }
    
    func configure(with platformName: String) {
        label.text = platformName
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func applyConstraints() {
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}
