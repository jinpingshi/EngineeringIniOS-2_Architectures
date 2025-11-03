//
//  ContactVIPERView.swift
//  ContactsArchitectureDemo
//
//  Created by Jinping Shi on 2025/11/3.
//

import SwiftUI

// MARK: - VIPER View (Pure UI, no logic)
struct ContactVIPERView: View {
    @ObservedObject var presenter: ContactVIPERPresenter
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                architectureLabel
                
                Spacer()
                
                if presenter.isLoading {
                    loadingView
                } else {
                    contactContent
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("VIPER - Contact Details")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            presenter.viewDidLoad()
        }
        .alert("Making Call", isPresented: $presenter.showCallAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(presenter.alertMessage)
        }
        .alert("Error", isPresented: $presenter.showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(presenter.errorMessage)
        }
    }
    
    // MARK: - View Components
    private var architectureLabel: some View {
        Text("VIPER Architecture")
            .font(.caption)
            .foregroundColor(.secondary)
            .padding(.top)
    }
    
    private var loadingView: some View {
        ProgressView("Loading...")
            .progressViewStyle(CircularProgressViewStyle())
    }
    
    private var contactContent: some View {
        VStack(spacing: 20) {
            Text(presenter.contactName)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(presenter.phoneNumber)
                .font(.body)
                .foregroundColor(.blue)
            
            if presenter.isCallButtonVisible {
                callButton
            }
        }
    }
    
    private var callButton: some View {
        Button(action: {
            presenter.didTapCallButton()
        }) {
            HStack {
                Image(systemName: "phone.fill")
                Text("Call")
            }
            .frame(width: 200, height: 50)
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
    }
}

// MARK: - Module Builder
extension ContactVIPERView {
    static func build() -> ContactVIPERView {
        let presenter = ContactVIPERPresenter()
        let interactor = ContactVIPERInteractor()
        let router = ContactVIPERRouter()
        
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        
        return ContactVIPERView(presenter: presenter)
    }
}
