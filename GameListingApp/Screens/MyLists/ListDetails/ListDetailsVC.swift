//
//  ProfileVC.swift
//  GameListingApp
//
//  Created by Yiğithan Sönmez on 31.12.2023.
//

import UIKit

protocol ListDetailsVCProtocol: AnyObject {
    func changeTitle(to listName: String)
    func reloadCollectionView()
    func navigateToGameDetails(vc: GameDetailsVC)
    func presentEditListView(vc: EditListVC)
}

final class ListDetailsVC: UIViewController {
    // MARK: - Typealias
    
    typealias Cell = CoverArtCollectionViewCell
    
    // MARK: - Properties
    private lazy var viewModel: ListDetailsVMProtocol = ListDetailsVM()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(Cell.self, forCellWithReuseIdentifier: Cell.identifier)
        return view
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("view Appeared ListDetailsVC")
    }
    
    // MARK: - Methods
    
    func configure(with listEntity: ListEntity) {
        title = listEntity.name
        viewModel.configure(with: listEntity)
    }
    
    func prepareView() {
        view.backgroundColor = .systemBackground
        viewModel.view = self
        
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let editListNavItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editListButtonTapped))
        navigationItem.rightBarButtonItem = editListNavItem
        
        applyConstraints()
    }
    
    // MARK: - Constraints
    
    private func applyConstraints(){
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10)
        ])
    }
    
    @objc func editListButtonTapped() {
        viewModel.editListButtonTapped()
    }
}

// MARK: - UICollectionViewDelegate

extension ListDetailsVC: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.getGamesCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.identifier, for: indexPath) as? Cell else { return UICollectionViewCell() }
        
        let urlString = viewModel.getCoverArtURLString(of: indexPath.item)
        cell.configure(with: urlString)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectItem(at: indexPath.item)
    }
}

extension ListDetailsVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return viewModel.getCellSize(viewWidth: view.frame.width)
    }
}

// MARK: - ListDetailsVCProtocol

extension ListDetailsVC: ListDetailsVCProtocol {
    func reloadCollectionView() {
        collectionView.reloadData()
    }
    
    func changeTitle(to listName: String) {
        title = listName
    }
    
    func navigateToGameDetails(vc: GameDetailsVC) {
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func presentEditListView(vc: EditListVC) {
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
    }
}
