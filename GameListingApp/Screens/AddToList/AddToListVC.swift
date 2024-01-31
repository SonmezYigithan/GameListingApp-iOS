//
//  AddToListVC.swift
//  GameListingApp
//
//  Created by Yiğithan Sönmez on 27.01.2024.
//

import UIKit

protocol AddToListVCProtocol: AnyObject {
    func dismissView()
    func presentCreateListView(vc: CreateListVC)
}

final class AddToListVC: UIViewController {
    private lazy var viewModel: AddToListVMProtocol = AddToListVM()
    
    var selectedCells = [Int]()
    
    var addButton: UIBarButtonItem? = nil
    
    private let createListButton: UIButton = {
        let button = UIButton()
        button.configuration = .tinted()
        button.configuration?.title = "New List..."
        button.configuration?.baseBackgroundColor = .systemGray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
//        ListSaveManager.shared.createList(name: "Favourites")
//        ListSaveManager.shared.createList(name: "Backlog")
        
        viewModel.view = self
        
        prepareView()
        applyConstraints()
    }
    
    func configure(gameId: Int, screenshot: String?) {
        viewModel.configureGameEntity(gameId: gameId, screenshotURL: screenshot)
    }
    
    func prepareView() {
        title = "Add to Lists"
        view.backgroundColor = .systemBackground
        
        view.addSubview(createListButton)
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        addButton = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addButtonClicked))
        navigationItem.rightBarButtonItem = addButton
        
        createListButton.addTarget(self, action: #selector(createListButtonClicked), for: .touchUpInside)
    }
    
    func applyConstraints() {
        NSLayoutConstraint.activate([
            createListButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            createListButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createListButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createListButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: createListButton.bottomAnchor, constant: 5),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc func addButtonClicked() {
        viewModel.addGameToSelectedList()
    }
    
    @objc func createListButtonClicked() {
        viewModel.createListButtonClicked()
    }
}

extension AddToListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getListCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let listName = viewModel.getListName(by: indexPath.row)
        cell.textLabel?.text = listName
        cell.selectionStyle = .none
        
        if viewModel.canCellClickable(at: indexPath.row) {
            cell.accessoryType = .none
        }
        else {
            cell.textLabel?.textColor = .systemGray
            cell.isUserInteractionEnabled = false
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if viewModel.canCellClickable(at: indexPath.row) {
            if selectedCells.contains(indexPath.row) {
                let index = selectedCells.firstIndex(of: indexPath.row)
                guard let index = index else {
                    tableView.deselectRow(at: indexPath, animated: true)
                    return indexPath
                }
                selectedCells.remove(at: index)
                viewModel.didUnselectList(at: indexPath.row)
                tableView.deselectRow(at: indexPath, animated: true)
                tableView.cellForRow(at: indexPath)?.accessoryType = .none
            }
            else {
                selectedCells.append(indexPath.row)
                tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
                viewModel.didSelectList(at: indexPath.row)
            }
        }
        else {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        return indexPath
    }
}

extension AddToListVC: AddToListVCProtocol {
    func dismissView() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    func disableEnableAddButton(isEnabled: Bool) {
        createListButton.isEnabled = isEnabled
    }
    
    func presentCreateListView(vc: CreateListVC) {
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
