//
//  DetailsView.swift
//  GameListingApp
//
//  Created by Yiğithan Sönmez on 26.01.2024.
//

import UIKit

final class GameDescriptionView: UIView {
    // MARK: Properties
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let gameNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 22.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let gameDeveloperLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17.0)
        label.textColor = .tintColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.text = "Release Date: "
        label.font = UIFont.boldSystemFont(ofSize: 17.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let gameDescriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareView()
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(name: String, description: String, developerName: String, releaseDate: String) {
        gameNameLabel.text = name
        gameDescriptionLabel.text = description
        gameDeveloperLabel.text = developerName
        releaseDateLabel.text = "Release Date: \(releaseDate)"
    }
    
    func prepareView() {
        addSubview(stackView)
        stackView.addArrangedSubview(gameNameLabel)
        stackView.addArrangedSubview(gameDeveloperLabel)
        stackView.addArrangedSubview(releaseDateLabel)
        stackView.addArrangedSubview(gameDescriptionLabel)
        
        stackView.setCustomSpacing(10, after: releaseDateLabel)
    }
    
    // MARK: Constraints
    
    func applyConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
