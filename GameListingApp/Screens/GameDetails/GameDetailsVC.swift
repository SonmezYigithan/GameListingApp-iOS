//
//  GameDetailsVC.swift
//  GameListingApp
//
//  Created by Yiğithan Sönmez on 3.01.2024.
//

import UIKit
import Kingfisher

protocol GameDetailsProtocol: AnyObject {
    func reloadCollectionView()
    func configureGameDetailUIElements(with arguments: GameDetailsArguments)
}

struct GameDetailsArguments {
    let coverURL: String
    let name: String
    let description: String
    let developers: [Developer]
}

final class GameDetailsVC: UIViewController {
    private lazy var viewModel: GameDetailsViewModelProtocol = GameDetailsViewModel()
    
    // MARK: - UI Element Declarations
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
    
    private let screenshotsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        prepareContentView()
        prepareScreenshotCollectionView()
        
        viewModel.view = self
        
        favouriteButton.addTarget(self, action: #selector(favouriteButtonTapped(_:)), for: .touchUpInside)
        
        applyConstraints()
    }
    
    func configure(with gameId: Int){
        viewModel.fetchGameDetails(with: gameId)
    }
    
    @objc private func favouriteButtonTapped(_ sender: UIButton){
        print("Button Pressed")
        viewModel.favouriteButtonTapped()
    }
    
    // MARK: - Constraints and Preparations
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
        
        screenshotsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            screenshotsCollectionView.topAnchor.constraint(equalTo: gameDescriptionLabel.bottomAnchor, constant: 15),
            screenshotsCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            screenshotsCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            screenshotsCollectionView.widthAnchor.constraint(equalToConstant: 500),
            screenshotsCollectionView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func prepareContentView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(coverImage)
        contentView.addSubview(favouriteButton)
        contentView.addSubview(gameNameLabel)
        contentView.addSubview(gameDescriptionLabel)
        contentView.addSubview(gameDeveloperLabel)
        contentView.addSubview(screenshotsCollectionView)
    }
    
    private func prepareScreenshotCollectionView() {
        screenshotsCollectionView.register(ScreenshotsCollectionViewCell.self, forCellWithReuseIdentifier: ScreenshotsCollectionViewCell.identifier)
        screenshotsCollectionView.bounces = true
        screenshotsCollectionView.dataSource = self
        screenshotsCollectionView.delegate = self
    }
}

// MARK: - Screenshots Collection View
extension GameDetailsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.getScreenshotCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ScreenshotsCollectionViewCell.identifier, for: indexPath) as! ScreenshotsCollectionViewCell
        
        let screenshotURL = viewModel.getFormattedScreenshotURL(of: indexPath.item)
        cell.configure(with: screenshotURL)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return viewModel.calculateCellSize(using: view.frame.width)
    }
}

extension GameDetailsVC: GameDetailsProtocol {
    func reloadCollectionView() {
        screenshotsCollectionView.reloadData()
    }
    
    func configureGameDetailUIElements(with arguments: GameDetailsArguments) {
        title = arguments.name
        
        if let url = URL(string: arguments.coverURL){
            coverImage.kf.setImage(with: url)
        }
        
        gameNameLabel.text = arguments.name
        gameDescriptionLabel.text = arguments.description
        
        // Todo: Handle Multiple Developers
        if let developer = arguments.developers.first?.company {
            gameDeveloperLabel.text = developer.name
        }
    }
}
