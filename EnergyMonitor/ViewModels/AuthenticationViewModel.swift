//
//  AuthenticationViewModel.swift
//  EnergyMonitor
//
//  Created by Mohamed Hamdi on 02/08/2025.
//

import Foundation
import FirebaseAuth
import Combine

class AuthenticationViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var isLoading = false
    @Published var errorMessage = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.currentUser = user
                self?.isAuthenticated = user != nil
            }
        }
    }
    
    func signIn(email: String, password: String) {
        isLoading = true
        errorMessage = ""
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func signUp(email: String, password: String) {
        isLoading = true
        errorMessage = ""
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func signOut() {
        try? Auth.auth().signOut()
    }
}
