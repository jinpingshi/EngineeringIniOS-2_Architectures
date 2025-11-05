//
//  ContentView.swift
//  ContactsArchitectureDemo
//
//  Created by Jinping Shi on 2025/11/3.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Text("iOS Architecture Patterns")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 50)
                
                Text("Comparison Demo")
                    .font(.title3)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                VStack(spacing: 20) {
                    // MVC Button (UIKit - Pure MVC with View + Controller)
                    NavigationLink(destination: ContactMVCViewControllerWrapper()) {
                        ArchitectureCard(
                            title: "MVC Architecture",
                            subtitle: "UIKit - View + Controller",
                            description: "Shows Massive View Controller",
                            color: .blue,
                            icon: "square.stack.3d.up"
                        )
                    }
                    
                    // MVVM Button (SwiftUI)
                    NavigationLink(destination: ContactMVVMView()) {
                        ArchitectureCard(
                            title: "MVVM Architecture",
                            subtitle: "SwiftUI - View + ViewModel",
                            description: "Modern data binding approach",
                            color: .green,
                            icon: "square.stack.3d.forward.dottedline"
                        )
                    }
                    
                    // VIPER Button (SwiftUI)
                    NavigationLink(destination: ContactVIPERView.build()) {
                        ArchitectureCard(
                            title: "VIPER Architecture",
                            subtitle: "SwiftUI - 5 Components",
                            description: "Enterprise-level separation",
                            color: .orange,
                            icon: "square.stack.3d.down.right"
                        )
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

// MARK: - UIKit Bridge (Minimal wrapper to present UIKit ViewController in SwiftUI)
struct ContactMVCViewControllerWrapper: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> UINavigationController {
        let viewController = ContactMVCViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        return navigationController
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        // No updates needed
    }
}

// MARK: - Architecture Card Component
struct ArchitectureCard: View {
    let title: String
    let subtitle: String
    let description: String
    let color: Color
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 40))
                .foregroundColor(.white)
                .frame(width: 60)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.9))
                
                Text(description)
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.white.opacity(0.7))
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(color)
        .cornerRadius(12)
    }
}
