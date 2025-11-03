//
//  ContactMVVMView.swift
//  ContactsArchitectureDemo
//
//  Created by Jinping Shi on 2025/11/3.
//

import SwiftUI

// MARK: - MVVM View (Clean, only UI)
struct ContactMVVMView: View {
    @StateObject private var viewModel = ContactMVVMViewModel()
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                Text("MVVM Architecture")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.top)
                
                Spacer()
                
                if viewModel.isLoading {
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle())
                } else {
                    VStack(spacing: 20) {
                        // View automatically updates via data binding
                        Text(viewModel.contactName)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text(viewModel.phoneNumber)
                            .font(.body)
                            .foregroundColor(.blue)
                        
                        if viewModel.canMakeCall {
                            Button(action: {
                                viewModel.handleCallAction()
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
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("MVVM - Contact Details")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.fetchContact()
        }
        .alert("Making Call", isPresented: $viewModel.showCallAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.getCallAlertMessage())
        }
        .alert("Error", isPresented: $viewModel.showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.errorMessage)
        }
    }
}
