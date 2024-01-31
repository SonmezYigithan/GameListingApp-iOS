//
//  CreateListVM.swift
//  GameListingApp
//
//  Created by Yiğithan Sönmez on 30.01.2024.
//

import Foundation

protocol CreateListVMProtocol {
    var view: CreateListVCProtocol? { get set }
    
    func createButtonClicked(listName: String, listDescription: String?)
    func listNameFieldEdited(listName: String)
}

final class CreateListVM {
    weak var view: CreateListVCProtocol?
}

extension CreateListVM: CreateListVMProtocol {
    func createButtonClicked(listName: String, listDescription: String?) {
        ListSaveManager.shared.createList(name: listName)
        view?.dismissView()
    }
    
    func listNameFieldEdited(listName: String) {
        if listName.count > 0 {
            view?.enableAddButton()
        }
        else {
            view?.disableAddButton()
        }
    }
}
