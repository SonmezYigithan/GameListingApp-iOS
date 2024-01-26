//
//  ScreenshotCollectionViewAdapter.swift
//  GameListingApp
//
//  Created by Yiğithan Sönmez on 26.01.2024.
//

import UIKit

protocol ScreenshotCollectionViewAdapterDelegate: AnyObject {
    
}

class ScreenshotCollectionViewAdapter: NSObject {
    // MARK: - Typealias
    
    typealias Cell = ScreenshotsCollectionViewCell
    
    // MARK: - Properties
    
    weak var delegate: ScreenshotCollectionViewAdapterDelegate?
    private var collectionView: UICollectionView
    private var screenshots: [ScreenshotUIModel]?
    private var viewFrameWidth: CGFloat
    
    init(collectionView: UICollectionView, viewFrameWidth: CGFloat) {
        self.collectionView = collectionView
        self.viewFrameWidth = viewFrameWidth
        super.init()
        configureCollectionView()
    }
    
    // MARK: - Configure
    
    private func configureCollectionView() {
        collectionView.register(Cell.self, forCellWithReuseIdentifier: Cell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func retrieveData(_ data: [ScreenshotUIModel]) {
        screenshots = data
        collectionView.reloadData()
    }
}

extension ScreenshotCollectionViewAdapter: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let screenshots = screenshots else {
            return 0
        }
        return screenshots.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let screenshots = screenshots else {
            return UICollectionViewCell()
        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.identifier, for: indexPath) as? Cell else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: screenshots[indexPath.item].url)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //let cellSize = CGSize(width: viewFrameWidth - 75, height: 200)
        let cellSize = CGSize(width: collectionView.bounds.width - 75, height: 200)
        return cellSize
    }
}
