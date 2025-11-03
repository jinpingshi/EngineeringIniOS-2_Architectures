//
//  ContactVIPERInteractor.swift
//  ContactsArchitectureDemo
//
//  Created by Jinping Shi on 2025/11/3.
//

import Foundation

// MARK: - Interactor Protocol
protocol ContactVIPERInteractorProtocol: AnyObject {
    func fetchContact()
}

// MARK: - Interactor (Business Logic)
class ContactVIPERInteractor: ContactVIPERInteractorProtocol {
    weak var presenter: ContactVIPERInteractorOutputProtocol?
    
    // MARK: - Business Logic Methods
    func fetchContact() {
        // Business logic: Fetch contact from service
        ContactService.shared.fetchContact { [weak self] result in
            switch result {
            case .success(let contact):
                // Entity is passed to presenter
                self?.presenter?.didFetchContact(contact)
            case .failure(let error):
                self?.presenter?.didFailToFetchContact(error)
            }
        }
    }
}
