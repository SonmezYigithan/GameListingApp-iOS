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
}

final class CreateListVM {
    weak var view: CreateListVCProtocol?
    
}

extension CreateListVM: CreateListVMProtocol {
    func createButtonClicked(listName: String, listDescription: String?) {
        ListSaveManager.shared.createList(name: listName)
        view?.dismissView()
    }
    
    
    
}
