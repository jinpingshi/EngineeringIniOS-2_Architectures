//
//  Untitled.swift
//  ContactsArchitectureDemo
//
//  Created by Jinping Shi on 2025/11/3.
//

import SwiftUI
import Combine

// MARK: - MVC Controller (Separate from View)
class ContactMVCController: ObservableObject {
    // MARK: - Model
    private var contact: Contact?
    
    // MARK: - Published Properties for View Binding
    @Published var contactName: String = ""
    @Published var phoneNumber: String = ""
    @Published var isLoading: Bool = false
    @Published var showCallButton: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    
    // MARK: - Business Logic (All in Controller - Still a problem!)
    func loadContact() {
        isLoading = true
        
        // Network request logic in Controller
        ContactService.shared.fetchContact { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let contact):
                    self?.contact = contact
                    self?.updateViewData(with: contact)
                case .failure(let error):
                    self?.handleError(error)
                }
            }
        }
    }
    
    // Data formatting logic in Controller
    private func updateViewData(with contact: Contact) {
        self.contactName = "Name: \(contact.name)"
        self.phoneNumber = "Phone: \(contact.phoneNumber)"
        
        // Validation logic in Controller
        self.showCallButton = contact.isPhoneNumberValid()
    }
    
    // Call handling logic in Controller
    func makeCall() {
        guard let contact = contact else { return }
        
        let phoneNumber = contact.phoneNumber
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "-", with: "")
        
        if let url = URL(string: "tel://\(phoneNumber)") {
            UIApplication.shared.open(url)
        }
        
        alertMessage = "Calling \(contact.name)\n\(contact.phoneNumber)"
        showAlert = true
    }
    
    private func handleError(_ error: Error) {
        errorMessage = error.localizedDescription
        showError = true
    }
}
