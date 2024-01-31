//
//  PlatformCollectionViewAdapter.swift
//  GameListingApp
//
//  Created by Yiğithan Sönmez on 26.01.2024.
//

import UIKit

protocol PlatformCollectionViewAdapterDelegate: AnyObject {
    
}

final class PlatformCollectionViewAdapter: NSObject {
    // MARK: - Typealias
    
    typealias Cell = PlatformCollectionViewCell
    
    // MARK: - Properties
    
    weak var delegate: PlatformCollectionViewAdapterDelegate?
    private var collectionView: UICollectionView
    private var platforms: [PlatformsUIModel]?
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init()
        configureCollectionView()
    }
    
    // MARK: - Configure
    
    private func configureCollectionView() {
        collectionView.register(Cell.self, forCellWithReuseIdentifier: Cell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func reloadData(_ data: [PlatformsUIModel]) {
        platforms = data
        collectionView.reloadData()
    }
    
    private func calculatePlatformCellSize(at index: Int, using frameWidth: CGFloat) -> CGSize {
        guard let platforms = platforms else {
            return CGSize(width: 0, height: 0)
        }
        
        let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: 50)
        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)]
        
        let estimatedFrame = NSString(string: platforms[index].shortenedName).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        
        let cellSize = CGSize(width: estimatedFrame.width + 25, height: 50)
        return cellSize
    }
}

// MARK: UICollectionViewDelegate

extension PlatformCollectionViewAdapter: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let platforms = platforms else {
            return 0
        }
        return platforms.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let platforms = platforms else {
            return UICollectionViewCell()
        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.identifier, for: indexPath) as? Cell else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: platforms[indexPath.item].shortenedName)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        calculatePlatformCellSize(at: indexPath.item, using: collectionView.frame.width)
    }
}
