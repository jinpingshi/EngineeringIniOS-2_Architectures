//
//  Contact.swift
//  ContactsArchitectureDemo
//
//  Created by Jinping Shi on 2025/11/3.
//

import Foundation

// MARK: - Shared Data Model
struct Contact {
    let id: String
    let name: String
    let phoneNumber: String
    let email: String
    
    // Data logic: validate phone number format
    func isPhoneNumberValid() -> Bool {
        let phoneRegex = "^[0-9+()-. ]+$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phonePredicate.evaluate(with: phoneNumber) && phoneNumber.count >= 10
    }
}

// MARK: - Mock Data Service
class ContactService {
    static let shared = ContactService()
    
    // Simulate network delay when fetching contact data
    func fetchContact(completion: @escaping (Result<Contact, Error>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let contact = Contact(
                id: "001",
                name: "John Smith",
                phoneNumber: "+1 (555) 123-4567",
                email: "john.smith@example.com"
            )
            completion(.success(contact))
        }
    }
}

// MARK: - Error Definition
enum ContactError: LocalizedError {
    case fetchFailed
    
    var errorDescription: String? {
        switch self {
        case .fetchFailed:
            return "Failed to fetch contact"
        }
    }
}
