//
//  ScreenshotsView.swift
//  GameListingApp
//
//  Created by Yiğithan Sönmez on 26.01.2024.
//

import UIKit

class ScreenshotsView: UIView {
    private var screenshotCollectionViewAdapter: ScreenshotCollectionViewAdapter?
    
    private let sectionLabel: UILabel = {
        let label = UILabel()
        label.text = "Screenshots"
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

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(sectionLabel)
        addSubview(collectionView)
        
        prepareCollectionView()
        
        screenshotCollectionViewAdapter = ScreenshotCollectionViewAdapter(collectionView: collectionView, viewFrameWidth: frame.width)
        screenshotCollectionViewAdapter?.delegate = self
        
        applyConstraints()
    }
    
    func configureScreenshotCollectionView(with screenshots: [ScreenshotUIModel]) {
        screenshotCollectionViewAdapter?.retrieveData(screenshots)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepareCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.bounces = true
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    func applyConstraints() {
        NSLayoutConstraint.activate([
            sectionLabel.topAnchor.constraint(equalTo: topAnchor),
            sectionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            sectionLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: sectionLabel.bottomAnchor, constant: 15),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.widthAnchor.constraint(equalToConstant: 500),
            collectionView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
}

extension ScreenshotsView: ScreenshotCollectionViewAdapterDelegate {
    
}
