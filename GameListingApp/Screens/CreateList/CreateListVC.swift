//
//  CreateListVC.swift
//  GameListingApp
//
//  Created by Yiğithan Sönmez on 30.01.2024.
//

import UIKit

protocol CreateListVCProtocol: AnyObject {
    func dismissView()
    func enableAddButton()
    func disableAddButton()
}

final class CreateListVC: UIViewController {
    // MARK: - Properties
    
    private lazy var viewModel: CreateListVMProtocol = CreateListVM()
    
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
    
    private let separatorView1 = SeparatorView()
    
    private let separatorView2 = SeparatorView()
    
    private var createButton: UIBarButtonItem?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.view = self
        
        prepareView()
        applyConstraints()
        
        guard let listName = listNameTextField.text else { return }
        viewModel.listNameFieldEdited(listName: listName)
    }
    
    func prepareView() {
        view.addSubview(listNameTextField)
        view.addSubview(listDescriptionTextField)
        view.addSubview(separatorView1)
        view.addSubview(separatorView2)
        
        view.backgroundColor = .systemBackground
        title = "Create List"
        
        listNameTextField.addTarget(self, action: #selector(listNameFieldEdited), for: .editingChanged)
        
        createButton = UIBarButtonItem(title: "Create", style: .plain, target: self, action: #selector(createButtonClicked))
        navigationItem.rightBarButtonItem = createButton
    }
    
    // MARK: - Actions
    
    @objc func createButtonClicked() {
        guard let listName = listNameTextField.text else { return }
        
        // listDescription is optional to have but listName is needed
        viewModel.createButtonClicked(listName: listName, listDescription: listDescriptionTextField.text)
    }
    
    @objc func listNameFieldEdited() {
        guard let listName = listNameTextField.text else { return }
        viewModel.listNameFieldEdited(listName: listName)
    }
    
    // MARK: - Constraints
    
    func applyConstraints() {
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
    }
}

// MARK: - CreateListVCProtocol

extension CreateListVC: CreateListVCProtocol {
    func dismissView() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    func enableAddButton() {
        createButton?.isEnabled = true
    }
    
    func disableAddButton() {
        createButton?.isEnabled = false
    }
}
