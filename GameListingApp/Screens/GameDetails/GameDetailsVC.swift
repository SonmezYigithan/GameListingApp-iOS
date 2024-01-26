//
//  GameDetailsVC.swift
//  GameListingApp
//
//  Created by Yiğithan Sönmez on 3.01.2024.
//

import UIKit
import Kingfisher
import WebKit
import SafariServices

protocol GameDetailsProtocol: AnyObject {
    func reloadScreenshotCollectionView()
    func reloadPlatformsCollectionView()
    func configureGameDetailUIElements(with arguments: GameDetailsArguments)
    func configureCoverBackground(with screenshotURL: String, isTranslucent: Bool)
    func presentSFSafariView(vc: SFSafariViewController)
}

struct GameDetailsArguments {
    let coverURL: String
    let name: String
    let description: String
    let developers: [Developer]
    let releaseDate: String
    let videoThumbnail: String?
    let isFavourite: Bool
}

final class GameDetailsVC: UIViewController {
    private lazy var viewModel: GameDetailsVMProtocol = GameDetailsVM()
    
    // MARK: - UI Element Declarations
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentInset = .zero
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
    
    private let favouriteButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 6
        button.configuration = .tinted()
        button.configuration?.baseBackgroundColor = .systemGray
        button.configuration?.title = "Add To Favourites"
        button.configuration?.image = UIImage(systemName: "heart")
        button.configuration?.imagePlacement = .leading
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
    
    private let whereToPlaySectionLabel: UILabel = {
        let label = UILabel()
        label.text = "Where To Play"
        label.textColor = .systemGray
        label.font = UIFont.boldSystemFont(ofSize: 17.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let platformsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = .init(top: 0, left: 15, bottom: 0, right: 0)
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    private let screenshotsSectionLabel: UILabel = {
        let label = UILabel()
        label.text = "Screenshots"
        label.textColor = .systemGray
        label.font = UIFont.boldSystemFont(ofSize: 17.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let screenshotsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = .init(top: 0, left: 15, bottom: 0, right: 0)
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    private let gameplayVideoSectionLabel: UILabel = {
        let label = UILabel()
        label.text = "Gameplay"
        label.textColor = .systemGray
        label.font = UIFont.boldSystemFont(ofSize: 17.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let videoThumbnailButton: UIButton = {
        let button = UIButton(type: .custom)
//        button.backgroundColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.contentMode = .scaleAspectFill
        button.imageView?.layer.cornerRadius = 20
        button.imageView?.layer.masksToBounds = true
        return button
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.view = self
        prepareView()
    }
    
    func configure(with gameId: Int){
        viewModel.fetchGameDetails(with: gameId)
    }
    
    @objc private func favouriteButtonTapped(_ sender: UIButton) {
        print("Button Pressed")
        viewModel.favouriteButtonTapped()
    }
    
    @objc private func videoThumbnailButtonTapped(_ sender: UIButton) {
        viewModel.videoThumbnailButtonTapped()
    }
    
    // MARK: - Constraints
    
    private func applyConstraints() {
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
            coverBackgroundImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            coverBackgroundImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            coverBackgroundImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            coverBackgroundImage.heightAnchor.constraint(equalToConstant: 320)
        ])
        
        NSLayoutConstraint.activate([
            coverImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            coverImage.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            coverImage.widthAnchor.constraint(equalToConstant: 220),
            coverImage.heightAnchor.constraint(equalToConstant: 300)
        ])
        
        NSLayoutConstraint.activate([
            favouriteButton.topAnchor.constraint(equalTo: coverBackgroundImage.bottomAnchor, constant: 15),
            favouriteButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            favouriteButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            favouriteButton.heightAnchor.constraint(equalToConstant: 50)
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
            releaseDateLabel.topAnchor.constraint(equalTo: gameDeveloperLabel.bottomAnchor, constant: 5),
            releaseDateLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            releaseDateLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
        ])
        
        NSLayoutConstraint.activate([
            gameDescriptionLabel.topAnchor.constraint(equalTo: releaseDateLabel.bottomAnchor, constant: 5),
            gameDescriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            gameDescriptionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
        ])
        
        NSLayoutConstraint.activate([
            whereToPlaySectionLabel.topAnchor.constraint(equalTo: gameDescriptionLabel.bottomAnchor, constant: 15),
            whereToPlaySectionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            whereToPlaySectionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            platformsCollectionView.topAnchor.constraint(equalTo: whereToPlaySectionLabel.bottomAnchor, constant: 15),
            platformsCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            platformsCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            platformsCollectionView.widthAnchor.constraint(equalToConstant: 500),
            platformsCollectionView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            screenshotsSectionLabel.topAnchor.constraint(equalTo: platformsCollectionView.bottomAnchor, constant: 15),
            screenshotsSectionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            screenshotsSectionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            screenshotsCollectionView.topAnchor.constraint(equalTo: screenshotsSectionLabel.bottomAnchor, constant: 15),
            screenshotsCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            screenshotsCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            screenshotsCollectionView.widthAnchor.constraint(equalToConstant: 500),
            screenshotsCollectionView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        NSLayoutConstraint.activate([
            gameplayVideoSectionLabel.topAnchor.constraint(equalTo: screenshotsCollectionView.bottomAnchor, constant: 15),
            gameplayVideoSectionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            gameplayVideoSectionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            videoThumbnailButton.topAnchor.constraint(equalTo: gameplayVideoSectionLabel.bottomAnchor, constant: 15),
            videoThumbnailButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            videoThumbnailButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            videoThumbnailButton.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    // MARK: - Prepare View
    
    private func prepareContentView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(coverBackgroundImage)
        contentView.addSubview(coverImage)
        contentView.addSubview(favouriteButton)
        contentView.addSubview(gameNameLabel)
        contentView.addSubview(gameDeveloperLabel)
        contentView.addSubview(releaseDateLabel)
        contentView.addSubview(gameDescriptionLabel)
        contentView.addSubview(whereToPlaySectionLabel)
        contentView.addSubview(platformsCollectionView)
        contentView.addSubview(screenshotsSectionLabel)
        contentView.addSubview(screenshotsCollectionView)
        contentView.addSubview(gameplayVideoSectionLabel)
        contentView.addSubview(videoThumbnailButton)
    }
    
    private func prepareScreenshotCollectionView() {
        screenshotsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        screenshotsCollectionView.register(ScreenshotsCollectionViewCell.self, forCellWithReuseIdentifier: ScreenshotsCollectionViewCell.identifier)
        screenshotsCollectionView.bounces = true
        screenshotsCollectionView.dataSource = self
        screenshotsCollectionView.delegate = self
        
        screenshotsCollectionView.showsHorizontalScrollIndicator = false
    }
    
    private func preparePlatformsCollectionView() {
        platformsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        platformsCollectionView.register(PlatformCollectionViewCell.self, forCellWithReuseIdentifier: PlatformCollectionViewCell.identifier)
        platformsCollectionView.bounces = true
        platformsCollectionView.dataSource = self
        platformsCollectionView.delegate = self
        
        platformsCollectionView.showsHorizontalScrollIndicator = false
    }
    
    func prepareView() {
        view.backgroundColor = .systemBackground
        prepareContentView()
        prepareScreenshotCollectionView()
        preparePlatformsCollectionView()
        
        favouriteButton.addTarget(self, action: #selector(favouriteButtonTapped(_:)), for: .touchUpInside)
        videoThumbnailButton.addTarget(self, action: #selector(videoThumbnailButtonTapped(_:)), for: .touchUpInside)

        applyConstraints()
    }
}

// MARK: - Screenshots Collection View
extension GameDetailsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView == screenshotsCollectionView) {
            return viewModel.getScreenshotCount()
        }
        else {
            return viewModel.getPlatformsCount()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(collectionView == screenshotsCollectionView) {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ScreenshotsCollectionViewCell.identifier, for: indexPath) as? ScreenshotsCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            let screenshotURL = viewModel.getFormattedScreenshotURL(of: indexPath.item)
            cell.configure(with: screenshotURL)
            
            return cell
        }
        else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlatformCollectionViewCell.identifier, for: indexPath) as? PlatformCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            let platformName = viewModel.getPlatformName(of: indexPath.item)
            cell.configure(with: platformName)
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if(collectionView == screenshotsCollectionView) {
            return viewModel.calculateScreenshotCellSize(using: view.frame.width)
        }
        else {
            return viewModel.calculatePlatformCellSize(at: indexPath.item , using: view.frame.width)
        }
    }
}

// MARK: - GameDetailsProtocol
extension GameDetailsVC: GameDetailsProtocol {
    func reloadScreenshotCollectionView() {
        screenshotsCollectionView.reloadData()
    }
    
    func reloadPlatformsCollectionView() {
        platformsCollectionView.reloadData()
    }
    
    func configureGameDetailUIElements(with arguments: GameDetailsArguments) {
        title = arguments.name
        
        if let url = URL(string: arguments.coverURL){
            coverImage.kf.setImage(with: url)
        }
        
        gameNameLabel.text = arguments.name
        gameDescriptionLabel.text = arguments.description
        
        if let developer = arguments.developers.first?.company {
            gameDeveloperLabel.text = developer.name
        }
        
        releaseDateLabel.text = "Release Date: \(arguments.releaseDate)"
        
        if let videoThumbnail = arguments.videoThumbnail {
            if let url = URL(string: videoThumbnail) {
                gameplayVideoSectionLabel.isHidden = false
                videoThumbnailButton.kf.setImage(with: url, for: .normal)
            }
        } else {
            gameplayVideoSectionLabel.isHidden = true
        }
        
        // handle FavouriteButton
        //        favouriteButton.isEnabled = !arguments.isFavourite
    }
    
    func configureCoverBackground(with screenshotURL: String, isTranslucent: Bool) {
        if let url = URL(string: screenshotURL){
            coverBackgroundImage.kf.setImage(with: url)
        }
        
        if isTranslucent {
            let blurEffect = UIBlurEffect(style: .light)
            let blurView = UIVisualEffectView(effect: blurEffect)
            blurView.translatesAutoresizingMaskIntoConstraints = false
            contentView.insertSubview(blurView, at: 1)
            
            NSLayoutConstraint.activate([
                blurView.topAnchor.constraint(equalTo: contentView.topAnchor),
                blurView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                blurView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                blurView.heightAnchor.constraint(equalToConstant: 320)
            ])
        }
    }
    
    func presentSFSafariView(vc: SFSafariViewController) {
        present(vc, animated: true)
    }
}
