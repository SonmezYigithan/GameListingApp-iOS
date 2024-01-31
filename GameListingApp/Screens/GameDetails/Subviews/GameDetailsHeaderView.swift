//
//  GameDetailsHeaderView.swift
//  GameListingApp
//
//  Created by Yiğithan Sönmez on 26.01.2024.
//

import UIKit
import Kingfisher

final class GameDetailsHeaderView: UIView {
    // MARK: - Properties
    
    private let coverBackgroundImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let coverImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 8
        image.layer.masksToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(coverBackgroundImage)
        addSubview(coverImage)
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCoverImage(with screenshotURL: String) {
        if let url = URL(string: screenshotURL){
            coverImage.kf.setImage(with: url)
        }
    }
    
    func configureCoverBackground(with screenshotURL: String, isTranslucent: Bool) {
        if let url = URL(string: screenshotURL){
            coverBackgroundImage.kf.setImage(with: url)
        }
        
        if isTranslucent {
            let blurEffect = UIBlurEffect(style: .light)
            let blurView = UIVisualEffectView(effect: blurEffect)
            blurView.translatesAutoresizingMaskIntoConstraints = false
            insertSubview(blurView, at: 1)
            
            NSLayoutConstraint.activate([
                blurView.topAnchor.constraint(equalTo: topAnchor),
                blurView.leadingAnchor.constraint(equalTo: leadingAnchor),
                blurView.trailingAnchor.constraint(equalTo: trailingAnchor),
                blurView.heightAnchor.constraint(equalToConstant: 320)
            ])
        }
    }
    
    // MARK: Constraints
    
    func applyConstraints() {
        NSLayoutConstraint.activate([
            coverBackgroundImage.topAnchor.constraint(equalTo: topAnchor),
            coverBackgroundImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            coverBackgroundImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            coverBackgroundImage.heightAnchor.constraint(equalToConstant: 320)
        ])
        
        NSLayoutConstraint.activate([
            coverImage.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            coverImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            coverImage.widthAnchor.constraint(equalToConstant: 220),
            coverImage.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
}
