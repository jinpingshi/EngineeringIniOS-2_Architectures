//
//  ContactVIPERRouter.swift
//  ContactsArchitectureDemo
//
//  Created by Jinping Shi on 2025/11/3.
//

import UIKit

// MARK: - Router Protocol
protocol ContactVIPERRouterProtocol: AnyObject {
    func openDialer(for phoneNumber: String)
}

// MARK: - Router (Navigation Logic)
class ContactVIPERRouter: ContactVIPERRouterProtocol {
    
    // MARK: - Navigation Methods
    func openDialer(for phoneNumber: String) {
        // Navigation logic: Clean and open phone dialer
        let cleanedNumber = phoneNumber
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "-", with: "")
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")
        
        if let url = URL(string: "tel://\(cleanedNumber)") {
            UIApplication.shared.open(url)
        }
    }
}
