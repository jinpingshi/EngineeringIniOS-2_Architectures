//
//  ContactMVCViewController.swift
//  ContactsArchitectureDemo
//
//  Created by Jinping Shi on 2025/11/3.
//

import UIKit

// MARK: - MVC Controller (All logic here - the "Massive" problem!)
class ContactMVCViewController: UIViewController {
    
    // MARK: - View (Controller owns the View)
    private var contactView: ContactMVCView {
        return view as! ContactMVCView
    }
    
    // MARK: - Model
    private var contact: Contact?
    
    // MARK: - Lifecycle
    override func loadView() {
        // Set custom view
        view = ContactMVCView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "MVC - Contact Details"
        
        // Setup button action
        contactView.callButton.addTarget(
            self,
            action: #selector(callButtonTapped),
            for: .touchUpInside
        )
        
        // Load data (Business logic in Controller)
        fetchContact()
    }
    
    // MARK: - Business Logic (All in Controller - Problem!)
    
    // Network request logic in Controller
    private func fetchContact() {
        contactView.showLoading()
        
        ContactService.shared.fetchContact { [weak self] result in
            DispatchQueue.main.async {
                self?.contactView.hideLoading()
                
                switch result {
                case .success(let contact):
                    self?.contact = contact
                    self?.updateView(with: contact)
                case .failure(let error):
                    self?.showError(error)
                }
            }
        }
    }
    
    // Data formatting logic in Controller
    private func updateView(with contact: Contact) {
        let displayName = "Name: \(contact.name)"
        let displayPhone = "Phone: \(contact.phoneNumber)"
        
        contactView.updateContactInfo(name: displayName, phone: displayPhone)
        
        // Data validation logic in Controller
        if contact.isPhoneNumberValid() {
            contactView.showCallButton()
        } else {
            contactView.hideCallButton()
        }
    }
    
    // Call handling logic in Controller
    @objc private func callButtonTapped() {
        guard let contact = contact else { return }
        
        // Phone number formatting logic in Controller
        let phoneNumber = contact.phoneNumber
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "-", with: "")
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")
        
        // Navigation logic in Controller
        if let url = URL(string: "tel://\(phoneNumber)") {
            UIApplication.shared.open(url)
        }
        
        // Alert presentation logic in Controller
        showCallAlert(for: contact)
    }
    
    // Alert logic in Controller
    private func showCallAlert(for contact: Contact) {
        let alert = UIAlertController(
            title: "Making Call",
            message: "Calling \(contact.name)\n\(contact.phoneNumber)",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // Error handling logic in Controller
    private func showError(_ error: Error) {
        let alert = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

/*
 MARK: - MVC Architecture Demonstrated:
 
 Model (Contact.swift):
 ✅ Simple data structure
 ✅ Contains data validation logic
 
 View (ContactMVCView.swift):
 ✅ Pure UI components
 ✅ Layout code only
 ✅ Public methods for Controller to update UI
 ✅ Reusable and testable
 
 Controller (ContactMVCViewController.swift):
 ❌ Network request logic (fetchContact)
 ❌ Data formatting logic (updateView)
 ❌ Data validation logic (isPhoneNumberValid check)
 ❌ Phone number formatting logic (replacingOccurrences)
 ❌ Navigation logic (UIApplication.shared.open)
 ❌ Alert presentation logic (showCallAlert, showError)
 ❌ Button action handling (callButtonTapped)
 
 This is the "Massive View Controller" problem!
 
 Compare with MVVM:
 - ViewModel handles: business logic, formatting, validation
 - View handles: UI only
 - Much cleaner separation
 
 Compare with VIPER:
 - Interactor: business logic
 - Presenter: formatting and validation
 - Router: navigation
 - View: UI only
 - Even better separation
 */
