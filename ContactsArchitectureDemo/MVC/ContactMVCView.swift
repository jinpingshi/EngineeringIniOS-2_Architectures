//
//  ContactMVCView.swift
//  ContactsArchitectureDemo
//
//  Created by Jinping Shi on 2025/11/3.
//

import UIKit

// MARK: - MVC View (Pure UI Components, no logic)
class ContactMVCView: UIView {
    
    // MARK: - UI Elements
    let architectureLabel: UILabel = {
        let label = UILabel()
        label.text = "MVC Architecture (UIKit)"
        label.font = .systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let phoneLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .center
        label.textColor = .systemBlue
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let callButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("📞 Call", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()
    
    let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - Setup (Only UI setup, no business logic)
    private func setupView() {
        backgroundColor = .systemBackground
        
        addSubview(architectureLabel)
        addSubview(nameLabel)
        addSubview(phoneLabel)
        addSubview(callButton)
        addSubview(loadingIndicator)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Architecture Label
            architectureLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
            architectureLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            // Name Label
            nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 100),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            // Phone Label
            phoneLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            phoneLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            phoneLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            phoneLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            // Call Button
            callButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            callButton.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor, constant: 40),
            callButton.widthAnchor.constraint(equalToConstant: 200),
            callButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Loading Indicator
            loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    // MARK: - Public Methods (View update methods, called by Controller)
    func showLoading() {
        loadingIndicator.startAnimating()
        nameLabel.isHidden = true
        phoneLabel.isHidden = true
        callButton.isHidden = true
    }
    
    func hideLoading() {
        loadingIndicator.stopAnimating()
        nameLabel.isHidden = false
        phoneLabel.isHidden = false
    }
    
    func updateContactInfo(name: String, phone: String) {
        nameLabel.text = name
        phoneLabel.text = phone
    }
    
    func showCallButton() {
        callButton.isHidden = false
    }
    
    func hideCallButton() {
        callButton.isHidden = true
    }
}
