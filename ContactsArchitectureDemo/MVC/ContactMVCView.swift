//
//  ContactMVCView.swift
//  ContactsArchitectureDemo
//
//  Created by Jinping Shi on 2025/11/3.
//

import SwiftUI

// MARK: - MVC View (Pure UI, no logic)
struct ContactMVCView: View {
    // Controller injection
    @StateObject private var controller: ContactMVCController
    
    init() {
        _controller = StateObject(wrappedValue: ContactMVCController())
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                architectureLabel
                
                Spacer()
                
                if controller.isLoading {
                    loadingView
                } else {
                    contactContent
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("MVC - Contact Details")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            controller.loadContact()
        }
        .alert("Making Call", isPresented: $controller.showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(controller.alertMessage)
        }
        .alert("Error", isPresented: $controller.showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(controller.errorMessage)
        }
    }
    
    // MARK: - View Components (Pure UI)
    private var architectureLabel: some View {
        Text("MVC Architecture")
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
            Text(controller.contactName)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(controller.phoneNumber)
                .font(.body)
                .foregroundColor(.blue)
            
            if controller.showCallButton {
                callButton
            }
        }
    }
    
    private var callButton: some View {
        Button(action: {
            controller.makeCall()
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
