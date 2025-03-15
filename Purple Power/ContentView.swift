import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @StateObject var userData = UserData()
    @State private var isOnboardingCompleted = UserDefaults.standard.bool(forKey: "OnboardingCompleted")
    @State private var isLoggedIn = false
    @State private var isGuestMode = false
    @State private var showNextScreen = false

    var body: some View {
        if !showNextScreen {
            SplashView(isLoggedIn: $isLoggedIn, isGuestMode: $isGuestMode, showNextScreen: $showNextScreen)
                .preferredColorScheme(.dark)
        } else if !isOnboardingCompleted {
            OnboardingView(isOnboardingCompleted: $isOnboardingCompleted)
                .onChange(of: isOnboardingCompleted) { newValue in
                    UserDefaults.standard.set(newValue, forKey: "OnboardingCompleted")
                }
                .preferredColorScheme(.dark)
        } else if !isLoggedIn {
            LoginView(isLoggedIn: $isLoggedIn, isGuestMode: $isGuestMode)
                .preferredColorScheme(.dark)
        } else {
            TabView {
                DashboardView(userData: userData)
                    .tabItem { Image(systemName: "house.fill"); Text("Home") }
                ChallengesView(userData: userData)
                    .tabItem { Image(systemName: "list.bullet"); Text("Challenges") }
                TimerView()
                    .tabItem { Image(systemName: "timer"); Text("Timer") }
                ProfileView(userData: userData)
                    .tabItem { Image(systemName: "person.fill"); Text("Profile") }
            }
            .accentColor(.purple)
            .preferredColorScheme(.dark)
            
        }
    }
}

#Preview {
    ContentView()
}
