import SwiftUI

struct DashboardView: View {
    @ObservedObject var userData: UserData
    @State private var pulseAnimation = false
    @State private var offsetY: CGFloat = 0

    var body: some View {
        NavigationView {
            ZStack {
                // Градиентный фон с анимацией
                LinearGradient(gradient: Gradient(colors: [Color.purple.opacity(0.8), Color.black, Color.indigo.opacity(0.6)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                    .overlay(
                        Circle()
                            .fill(Color.purple.opacity(0.2))
                            .frame(width: 300, height: 300)
                            .blur(radius: 50)
                            .offset(x: -150, y: -200 + offsetY)
                            .animation(.easeInOut(duration: 5).repeatForever(autoreverses: true), value: offsetY)
                    )
                    .onAppear { offsetY = 50 }

                VStack(spacing: 20) {
                    // Шаги
                    Text("Steps: \(userData.progress.steps)")
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: .purple.opacity(0.5), radius: 5)
                        .scaleEffect(pulseAnimation ? 1.1 : 1.0)
                        .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: pulseAnimation)
                        .onAppear { pulseAnimation = true }

                    // Кристаллы
                    HStack(spacing: 20) {
                        CrystalView(name: "Strength", value: userData.progress.strength)
                        CrystalView(name: "Endurance", value: userData.progress.endurance)
                        CrystalView(name: "Speed", value: userData.progress.speed)
                    }
                    .padding()
                    .background(Color.black.opacity(0.2))
                    .cornerRadius(15)
                    .shadow(color: .purple.opacity(0.3), radius: 10)

                    // Текущий челлендж
                    VStack(spacing: 10) {
                        Text("Current Challenge")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.9))
                        if let challenge = userData.challenges.first(where: { !$0.isCompleted }) {
                            ChallengeCard(challenge: challenge)
                                .transition(.scale)
                        }
                    }
                    .padding()
                    .background(Color.black.opacity(0.15))
                    .cornerRadius(15)
                    .shadow(color: .indigo.opacity(0.3), radius: 10)

                    Spacer()
                }
                .padding(.top, 20)
            }
            .navigationTitle("Purple Power")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: ProfileView(userData: userData)) {
                        Image(systemName: "person.circle.fill")
                            .foregroundColor(.white)
                            .scaleEffect(1.2)
                    }
                }
            }
        }
    }
}

struct CrystalView: View {
    let name: String
    let value: Int
    @State private var isAnimating = false

    var body: some View {
        VStack {
            Image(systemName: "hexagon.fill")
                .foregroundColor(.purple)
                .scaleEffect(isAnimating ? 1.2 : 1.0)
                .animation(.spring(response: 0.5, dampingFraction: 0.6), value: isAnimating)
                .onAppear { isAnimating = true }
            Text("\(value)")
                .font(.title2)
                .foregroundColor(.white)
            Text(name)
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
        }
    }
}
