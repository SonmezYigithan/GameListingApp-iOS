//
//  WhereToPlayView.swift
//  GameListingApp
//
//  Created by Yiğithan Sönmez on 27.01.2024.
//

import UIKit

final class WhereToPlayView: UIView {
    // MARK: - Properties
    
    private var collectionViewAdapter: PlatformCollectionViewAdapter?
    
    private let sectionLabel: UILabel = {
        let label = UILabel()
        label.text = "Where To Play"
        label.textColor = .systemGray
        label.font = UIFont.boldSystemFont(ofSize: 17.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = .init(top: 0, left: 15, bottom: 0, right: 0)
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(sectionLabel)
        addSubview(collectionView)
        
        prepareCollectionView()
        applyConstraints()
    }
    
    func configureScreenshotCollectionView(with platforms: [PlatformsUIModel]) {
        collectionViewAdapter?.reloadData(platforms)
    }
    
    private func prepareCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.bounces = true
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionViewAdapter = PlatformCollectionViewAdapter(collectionView: collectionView)
        collectionViewAdapter?.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Constraints
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            sectionLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            sectionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            sectionLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: sectionLabel.bottomAnchor, constant: 15),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.widthAnchor.constraint(equalToConstant: 500),
            collectionView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

extension WhereToPlayView: PlatformCollectionViewAdapterDelegate {
    
}
