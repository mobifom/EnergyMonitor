//
//  LoginView.swift
//  EnergyMonitor
//
//  Created by Mohamed Hamdi on 02/08/2025.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @EnvironmentObject var localizationManager: LocalizationManager
    @State private var email = ""
    @State private var password = ""
    @State private var isSignUp = false
    @State private var confirmPassword = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Logo and Title
                    VStack(spacing: 16) {
                        Image(systemName: "bolt.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.green)
                        
                        Text("Energy Monitor")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text(localizationManager.isArabic ?
                             "راقب استهلاكك للطاقة ووفر في فاتورتك" :
                             "Monitor your energy usage and save on bills")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 40)
                    
                    // Form
                    VStack(spacing: 16) {
                        TextField("Email", text: $email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        
                        SecureField("Password", text: $password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        if isSignUp {
                            SecureField("Confirm Password", text: $confirmPassword)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        
                        if !authViewModel.errorMessage.isEmpty {
                            Text(authViewModel.errorMessage)
                                .foregroundColor(.red)
                                .font(.caption)
                        }
                        
                        Button(action: handleAuthentication) {
                            HStack {
                                if authViewModel.isLoading {
                                    ProgressView()
                                        .scaleEffect(0.8)
                                }
                                Text(isSignUp ? "Sign Up" : "Sign In")
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(12)
                        }
                        .disabled(authViewModel.isLoading || email.isEmpty || password.isEmpty)
                        
                        Button(action: { isSignUp.toggle() }) {
                            Text(isSignUp ?
                                 "Already have an account? Sign In" :
                                 "Don't have an account? Sign Up")
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.horizontal, 32)
                    
                    Spacer()
                    
                    // Language Toggle
                    Button(action: toggleLanguage) {
                        HStack {
                            Image(systemName: "globe")
                            Text(localizationManager.currentLanguage == .arabic ? "English" : "العربية")
                        }
                        .foregroundColor(.blue)
                    }
                    .padding(.bottom, 20)
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private func handleAuthentication() {
        if isSignUp {
            guard password == confirmPassword else {
                authViewModel.errorMessage = "Passwords don't match"
                return
            }
            authViewModel.signUp(email: email, password: password)
        } else {
            authViewModel.signIn(email: email, password: password)
        }
    }
    
    private func toggleLanguage() {
        let newLanguage: LocalizationManager.Language =
            localizationManager.currentLanguage == .arabic ? .english : .arabic
        localizationManager.setLanguage(newLanguage)
    }
}
