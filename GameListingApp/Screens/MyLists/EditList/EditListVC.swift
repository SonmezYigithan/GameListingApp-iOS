//
//  EditListVC.swift
//  GameListingApp
//
//  Created by Yiğithan Sönmez on 3.02.2024.
//

import UIKit

protocol EditListVCProtocol: AnyObject {
    func dismissView()
    func enableSaveButton()
    func disableSaveButton()
}

protocol EditListDelegate: AnyObject {
    func didEditSaved()
}

class EditListVC: UIViewController {
    // MARK: - Typealias
    
    typealias Cell = EditListTableViewCell
    
    // MARK: - Properties
    lazy var viewModel: EditListVMProtocol = EditListVM()
    
    private let listNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter List Name..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let listDescriptionTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter List Description..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(Cell.self, forCellReuseIdentifier: Cell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let separatorView1 = SeparatorView()
    
    private let separatorView2 = SeparatorView()
    
    private lazy var saveNavButton: UIBarButtonItem? = nil
    
    weak var delegate: EditListDelegate?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
    }
    
    func prepareView() {
        view.backgroundColor = .systemBackground
        title = "Edit List"
        viewModel.view = self
        
        view.addSubview(listNameTextField)
        view.addSubview(listDescriptionTextField)
        view.addSubview(separatorView1)
        view.addSubview(separatorView2)
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isEditing = true
        
        saveNavButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonTapped))
        navigationItem.rightBarButtonItem = saveNavButton
        
        listNameTextField.addTarget(self, action: #selector(onListNameFieldEdited), for: .editingChanged)
        
        applyConstraints()
    }
    
    func configure(listEntity: ListEntity) {
        listNameTextField.text = listEntity.name
        listDescriptionTextField.text = ""
        viewModel.listEntity = listEntity
    }
    
    // MARK: - Actions
    
    @objc private func onListNameFieldEdited() {
        guard let listName = listNameTextField.text else { return }
        viewModel.listNameFieldEdited(listName: listName)
    }
    
    @objc private func saveButtonTapped() {
        guard let listName = listNameTextField.text else { return }
        viewModel.saveButtonTapped(changedListName: listName)
    }
    
    // MARK: - Constraints
    
    private func applyConstraints() {
        separatorView1.translatesAutoresizingMaskIntoConstraints = false
        separatorView2.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            listNameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            listNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            listNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        
        NSLayoutConstraint.activate([
            separatorView1.topAnchor.constraint(equalTo: listNameTextField.bottomAnchor, constant: 15),
            separatorView1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            separatorView1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            separatorView1.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        NSLayoutConstraint.activate([
            listDescriptionTextField.topAnchor.constraint(equalTo: separatorView1.bottomAnchor, constant: 15),
            listDescriptionTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            listDescriptionTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            separatorView2.topAnchor.constraint(equalTo: listDescriptionTextField.bottomAnchor, constant: 15),
            separatorView2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            separatorView2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            separatorView2.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: separatorView2.bottomAnchor, constant: 15),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}

// MARK: - UITableViewDelegate

extension EditListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.getGameCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.identifier, for: indexPath) as? Cell else { return UITableViewCell() }
        
        cell.configure(gameEntity: viewModel.getGame(at: indexPath.row))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 138
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.selectionStyle = .default
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        viewModel.moveCell(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, success) in
            self.viewModel.deleteGame(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        let swipeActions = UISwipeActionsConfiguration(actions: [delete])
        return swipeActions
    }
}

// MARK: - EditListVCProtocol

extension EditListVC: EditListVCProtocol {
    func dismissView() {
        dismiss(animated: true)
        delegate?.didEditSaved()
    }
    
    func enableSaveButton() {
        saveNavButton?.isEnabled = true
    }
    
    func disableSaveButton() {
        saveNavButton?.isEnabled = false
    }
}
