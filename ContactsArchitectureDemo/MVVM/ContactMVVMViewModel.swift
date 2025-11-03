//
//  ContactMVVMViewModel.swift
//  ContactsArchitectureDemo
//
//  Created by Jinping Shi on 2025/11/3.
//

import SwiftUI
import Combine

// MARK: - ViewModel (Business Logic Separated from View)
class ContactMVVMViewModel: ObservableObject {
    // MARK: - Published Properties for Data Binding
    @Published var contactName: String = ""
    @Published var phoneNumber: String = ""
    @Published var isLoading: Bool = false
    @Published var canMakeCall: Bool = false
    @Published var showCallAlert: Bool = false
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    
    // MARK: - Private Properties
    private var contact: Contact?
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Business Logic (Separated from View)
    func fetchContact() {
        isLoading = true
        
        ContactService.shared.fetchContact { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let contact):
                    self?.contact = contact
                    self?.processContactData(contact)
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    self?.showError = true
                }
            }
        }
    }
    
    private func processContactData(_ contact: Contact) {
        // Data formatting logic in ViewModel
        contactName = "Name: \(contact.name)"
        phoneNumber = "Phone: \(contact.phoneNumber)"
        canMakeCall = contact.isPhoneNumberValid()
    }
    
    func handleCallAction() {
        guard let contact = contact else { return }
        
        let phoneNumber = contact.phoneNumber
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "-", with: "")
        
        if let url = URL(string: "tel://\(phoneNumber)") {
            UIApplication.shared.open(url)
        }
        
        showCallAlert = true
    }
    
    func getCallAlertMessage() -> String {
        guard let contact = contact else { return "" }
        return "Calling \(contact.name)\n\(contact.phoneNumber)"
    }
}
