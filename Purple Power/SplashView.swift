import SwiftUI
import FirebaseAuth

struct SplashView: View {
    @Binding var isLoggedIn: Bool
    @Binding var isGuestMode: Bool
    @Binding var showNextScreen: Bool
    @State private var scale = 1.0

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.purple, Color.black]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack {
                Image(systemName: "bolt.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.white)
                    .scaleEffect(scale)
                    .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: scale)
                Text("V: Power")
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
            }
        }
        .onAppear {
            scale = 1.2
            checkAuthStatus()
        }
    }

    func checkAuthStatus() {
        if let user = Auth.auth().currentUser {
            isLoggedIn = true
            isGuestMode = user.isAnonymous
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                showNextScreen = true
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                showNextScreen = true
            }
        }
    }
}
