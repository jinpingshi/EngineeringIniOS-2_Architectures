//
//  ContactVIPERPresenter.swift
//  ContactsArchitectureDemo
//
//  Created by Jinping Shi on 2025/11/3.
//

import Foundation
import Combine

// MARK: - Presenter Protocol
protocol ContactVIPERPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didTapCallButton()
}

// MARK: - Presenter (Coordinates everything & manages UI state)
class ContactVIPERPresenter: ObservableObject {
    // MARK: - Published Properties for UI
    @Published var contactName: String = ""
    @Published var phoneNumber: String = ""
    @Published var isLoading: Bool = false
    @Published var isCallButtonVisible: Bool = false
    @Published var showCallAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    
    // MARK: - VIPER Components
    var interactor: ContactVIPERInteractorProtocol?
    var router: ContactVIPERRouterProtocol?
    
    // MARK: - Private Properties
    private var currentContact: Contact?
}

// MARK: - Presenter Protocol Implementation
extension ContactVIPERPresenter: ContactVIPERPresenterProtocol {
    func viewDidLoad() {
        isLoading = true
        interactor?.fetchContact()
    }
    
    func didTapCallButton() {
        guard let contact = currentContact else { return }
        
        // Tell router to handle navigation
        router?.openDialer(for: contact.phoneNumber)
        
        // Update UI
        alertMessage = "Calling \(contact.name)\n\(contact.phoneNumber)"
        showCallAlert = true
    }
}

// MARK: - Interactor Output Protocol
protocol ContactVIPERInteractorOutputProtocol: AnyObject {
    func didFetchContact(_ contact: Contact)
    func didFailToFetchContact(_ error: Error)
}

// MARK: - Interactor Output Implementation
extension ContactVIPERPresenter: ContactVIPERInteractorOutputProtocol {
    func didFetchContact(_ contact: Contact) {
        currentContact = contact
        
        DispatchQueue.main.async { [weak self] in
            self?.isLoading = false
            
            // Format data for display (Presentation logic)
            self?.contactName = "Name: \(contact.name)"
            self?.phoneNumber = "Phone: \(contact.phoneNumber)"
            
            // Determine if call button should be shown
            self?.isCallButtonVisible = contact.isPhoneNumberValid()
        }
    }
    
    func didFailToFetchContact(_ error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.isLoading = false
            self?.errorMessage = error.localizedDescription
            self?.showError = true
        }
    }
}
