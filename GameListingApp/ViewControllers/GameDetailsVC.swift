//
//  GameDetailsVC.swift
//  GameListingApp
//
//  Created by Yiğithan Sönmez on 3.01.2024.
//

import UIKit

final class GameDetailsVC: UIViewController {
    
    private var screenshots = [Screenshot]()
    
    private var gameDetails: Game?
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let coverImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 8
        image.layer.masksToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let gameNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let favouriteButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 6
        button.tintColor = .white
        button.backgroundColor = .systemPink
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.text = "Add to Favourites"
        return button
    }()
    
    private let gameDeveloperLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17.0)
        label.textColor = .tintColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let gameDescriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let screenShotsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(coverImage)
        contentView.addSubview(favouriteButton)
        contentView.addSubview(gameNameLabel)
        contentView.addSubview(gameDescriptionLabel)
        contentView.addSubview(gameDeveloperLabel)
        contentView.addSubview(screenShotsCollectionView)
        
        favouriteButton.addTarget(self, action: #selector(favouriteButtonTapped(_:)), for: .touchUpInside)
        
        applyConstraints()
        
        screenShotsCollectionView.register(ScreenshotsCollectionViewCell.self, forCellWithReuseIdentifier: ScreenshotsCollectionViewCell.identifier)
        screenShotsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        screenShotsCollectionView.bounces = true
        screenShotsCollectionView.dataSource = self
        screenShotsCollectionView.delegate = self
        
    }
    
    func configure(with game:Game){
        title = game.name
        gameDetails = game
        coverImage.kf.setImage(with: game.cover?.formattedURL)
        gameNameLabel.text = game.name ?? ""
        gameDescriptionLabel.text = game.summary
        if let developer = game.developer {
            gameDeveloperLabel.text = developer[0].company?.name
        }
        
        NetworkManager.shared.fetchScreenshots(of: game.id) { result in
            switch result {
            case .success(let screenshots):
                self.screenshots.append(contentsOf: screenshots)
                self.screenShotsCollectionView.reloadData()
            case.failure(let error):
                print(error)
            }
        }
    }
    
    @objc private func favouriteButtonTapped(_ sender: UIButton){
        guard let game = gameDetails else {
            return
        }
        
        guard let coverURL = game.cover?.url else {
            return
        }
        
        FavouriteGameManager.shared.addGameToFavourites(gameId: Int64(game.id), screenshotURL: coverURL)
    }
    
    private func applyConstraints(){
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        let hConst = contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 2)
        hConst.isActive = true
        hConst.priority = UILayoutPriority(50)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            coverImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            coverImage.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            coverImage.widthAnchor.constraint(equalToConstant: 165),
            coverImage.heightAnchor.constraint(equalToConstant: 225)
        ])
        
        NSLayoutConstraint.activate([
            favouriteButton.topAnchor.constraint(equalTo: coverImage.bottomAnchor, constant: 15),
            favouriteButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            favouriteButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            favouriteButton.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        NSLayoutConstraint.activate([
            gameNameLabel.topAnchor.constraint(equalTo: favouriteButton.bottomAnchor, constant: 15),
            gameNameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            gameNameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
        ])
        
        NSLayoutConstraint.activate([
            gameDeveloperLabel.topAnchor.constraint(equalTo: gameNameLabel.bottomAnchor, constant: 5),
            gameDeveloperLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            gameDeveloperLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
        ])
        
        NSLayoutConstraint.activate([
            gameDescriptionLabel.topAnchor.constraint(equalTo: gameDeveloperLabel.bottomAnchor, constant: 5),
            gameDescriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            gameDescriptionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
        ])
        
        NSLayoutConstraint.activate([
            screenShotsCollectionView.topAnchor.constraint(equalTo: gameDescriptionLabel.bottomAnchor, constant: 15),
            screenShotsCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            screenShotsCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            screenShotsCollectionView.widthAnchor.constraint(equalToConstant: 500),
            screenShotsCollectionView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
}

extension GameDetailsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if screenshots.count == 0{
            return 0
        }
        
        if let screenshotsCount = screenshots[0].screenshots {
            return screenshotsCount.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ScreenshotsCollectionViewCell.identifier, for: indexPath) as! ScreenshotsCollectionViewCell
        
        if let screenshotURLs = screenshots[0].screenshots{
            if let screenshotURL = screenshotURLs[indexPath.item].url{
                if let url = URL(string: screenshotURL.convertIgdbPathToURLString(replaceOccurrencesOf: "t_thumb", replaceWith: "t_original")) {
                    cell.configure(with: url)
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = CGSize(width: view.frame.width - 75, height: 200)
        //        print(cellSize)
        return cellSize
    }
    
    
}
