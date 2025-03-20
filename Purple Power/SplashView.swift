import SwiftUI
import FirebaseAuth

struct SplashView: View {
    @Binding var isLoggedIn: Bool
    @Binding var isGuestMode: Bool
    @Binding var showNextScreen: Bool
    @State private var scale = 1.0
    @State private var rotation = 0.0
    @State private var particleOffset: CGFloat = 0

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.purple.opacity(0.9), Color.black, Color.indigo.opacity(0.7)]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            ForEach(0..<20, id: \.self) { _ in
                Circle()
                    .fill(Color.purple.opacity(Double.random(in: 0.2...0.5)))
                    .frame(width: Double.random(in: 5...15), height: Double.random(in: 5...15))
                    .offset(x: Double.random(in: -150...150), y: Double.random(in: -300...300) + particleOffset)
                    .animation(.easeInOut(duration: Double.random(in: 2...4)).repeatForever(autoreverses: true), value: particleOffset)
            }
            .onAppear { particleOffset = 50 }

            VStack {
                Image(systemName: "bolt.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .foregroundColor(.white)
                    .scaleEffect(scale)
                    .rotationEffect(.degrees(rotation))
                    .shadow(color: .purple.opacity(0.8), radius: 15)
                    .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: scale)
                    .animation(.linear(duration: 10).repeatForever(autoreverses: false), value: rotation)

                Text("V: Power")
                    .font(.system(size: 40, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: .purple.opacity(0.5), radius: 10)
                    .opacity(scale > 1.1 ? 1.0 : 0.5)
                    .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: scale)
            }
        }
        .onAppear {
            scale = 1.2
            rotation = 360
            checkAuthStatus()
        }
    }

    func checkAuthStatus() {
        if let user = Auth.auth().currentUser {
            isLoggedIn = true
            isGuestMode = user.isAnonymous
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                // showNextScreen = true
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                // showNextScreen = true
            }
        }
    }
    
}
