//
//  GameDetailsVC.swift
//  GameListingApp
//
//  Created by Yiğithan Sönmez on 3.01.2024.
//

import UIKit
import Kingfisher
import SafariServices

protocol GameDetailsProtocol: AnyObject {
    func configureGameDetailUIElements(with arguments: GameDetailsArguments)
    func configureCoverBackground(with screenshotURL: String, isTranslucent: Bool)
    func presentSFSafariView(vc: SFSafariViewController)
    func presentAddToListView(vc: AddToListVC)
    func configureScreenshotCollectionView(with screenshots: [ScreenshotUIModel])
    func configurePlatformsCollectionView(with screenshots: [PlatformsUIModel])
}

struct GameDetailsArguments {
    let coverURL: String
    let name: String
    let description: String
    let developers: [Developer]
    let releaseDate: String
    let videoThumbnail: String?
}

final class GameDetailsVC: UIViewController {
    private lazy var viewModel: GameDetailsVMProtocol = GameDetailsVM()
    
    // MARK: - Properties
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
    
    private let header = GameDetailsHeaderView()
    
    private let addToListButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 6
        button.configuration = .tinted()
        button.configuration?.baseBackgroundColor = .systemGray
        button.configuration?.title = "Add to Lists"
        button.configuration?.image = UIImage(systemName: "plus")
        button.configuration?.imagePlacement = .leading
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let gameDescriptionView = GameDescriptionView()
    
    private let whereToPlayView = WhereToPlayView()
    
    private let screenshotsView = ScreenshotsView()
    
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
    
    // MARK: Actions
    
    @objc private func addToListButtonTapped(_ sender: UIButton) {
        viewModel.addToListButtonTapped()
    }
    
    @objc private func videoThumbnailButtonTapped(_ sender: UIButton) {
        viewModel.videoThumbnailButtonTapped()
    }
    
    // MARK: - Constraints
    
    private func applyConstraints() {
        header.translatesAutoresizingMaskIntoConstraints = false
        gameDescriptionView.translatesAutoresizingMaskIntoConstraints = false
        screenshotsView.translatesAutoresizingMaskIntoConstraints = false
        whereToPlayView.translatesAutoresizingMaskIntoConstraints = false
        
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
            header.topAnchor.constraint(equalTo: contentView.topAnchor),
            header.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            header.heightAnchor.constraint(equalToConstant: 320)
        ])
        
        NSLayoutConstraint.activate([
            addToListButton.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 15),
            addToListButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            addToListButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            addToListButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            gameDescriptionView.topAnchor.constraint(equalTo: addToListButton.bottomAnchor, constant: 15),
            gameDescriptionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            gameDescriptionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
        ])
        
        NSLayoutConstraint.activate([
            whereToPlayView.topAnchor.constraint(equalTo: gameDescriptionView.bottomAnchor, constant: 5),
            whereToPlayView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            whereToPlayView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            whereToPlayView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        NSLayoutConstraint.activate([
            screenshotsView.topAnchor.constraint(equalTo: whereToPlayView.bottomAnchor, constant: 15),
            screenshotsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            screenshotsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            screenshotsView.widthAnchor.constraint(equalTo: view.widthAnchor),
            screenshotsView.heightAnchor.constraint(equalToConstant: 250)
        ])
        
        NSLayoutConstraint.activate([
            gameplayVideoSectionLabel.topAnchor.constraint(equalTo: screenshotsView.bottomAnchor, constant: 15),
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
    
    func prepareView() {
        view.backgroundColor = .systemBackground
        prepareContentView()
        
        addToListButton.addTarget(self, action: #selector(addToListButtonTapped(_:)), for: .touchUpInside)
        videoThumbnailButton.addTarget(self, action: #selector(videoThumbnailButtonTapped(_:)), for: .touchUpInside)
        
        applyConstraints()
    }
    
    private func prepareContentView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(header)
        contentView.addSubview(addToListButton)
        contentView.addSubview(gameDescriptionView)
        contentView.addSubview(whereToPlayView)
        contentView.addSubview(screenshotsView)
        contentView.addSubview(gameplayVideoSectionLabel)
        contentView.addSubview(videoThumbnailButton)
    }
}

// MARK: - GameDetailsProtocol

extension GameDetailsVC: GameDetailsProtocol {
    func configurePlatformsCollectionView(with screenshots: [PlatformsUIModel]) {
        whereToPlayView.configureScreenshotCollectionView(with: screenshots)
    }
    
    func configureGameDetailUIElements(with arguments: GameDetailsArguments) {
        title = arguments.name
        header.configureCoverImage(with: arguments.coverURL)
        
        var developerName = ""
        if let developer = arguments.developers.first?.company {
            developerName = developer.name ?? ""
        }
        
        gameDescriptionView.configure(name: arguments.name, description: arguments.description, developerName: developerName, releaseDate: arguments.releaseDate)
        
        if let videoThumbnail = arguments.videoThumbnail {
            if let url = URL(string: videoThumbnail) {
                gameplayVideoSectionLabel.isHidden = false
                videoThumbnailButton.kf.setImage(with: url, for: .normal)
            }
        } else {
            gameplayVideoSectionLabel.isHidden = true
        }
    }
    
    func configureCoverBackground(with screenshotURL: String, isTranslucent: Bool) {
        header.configureCoverBackground(with: screenshotURL, isTranslucent: isTranslucent)
    }
    
    func presentSFSafariView(vc: SFSafariViewController) {
        present(vc, animated: true)
    }
    
    func configureScreenshotCollectionView(with screenshots: [ScreenshotUIModel]) {
        screenshotsView.configureScreenshotCollectionView(with: screenshots)
    }
    
    func presentAddToListView(vc: AddToListVC) {
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
    }
}

extension GameDetailsVC: ScreenshotCollectionViewAdapterDelegate {
    
}
