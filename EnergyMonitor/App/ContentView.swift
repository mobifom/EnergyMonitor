import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @EnvironmentObject var localizationManager: LocalizationManager
    
    var body: some View {
        Group {
            if authViewModel.isAuthenticated {
                MainTabView()
            } else {
                LoginView()
            }
        }
        .animation(.easeInOut, value: authViewModel.isAuthenticated)
    }
}
