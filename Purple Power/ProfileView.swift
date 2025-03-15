import SwiftUI

struct ProfileView: View {
    @ObservedObject var userData: UserData
    @State private var selectedAvatar = "ninja"
    @State private var offsetY: CGFloat = 0

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.purple.opacity(0.7), Color.black, Color.indigo.opacity(0.5)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
                .overlay(
                    Circle()
                        .fill(Color.indigo.opacity(0.2))
                        .frame(width: 400, height: 400)
                        .blur(radius: 60)
                        .offset(x: 100, y: 300 + offsetY)
                        .animation(.easeInOut(duration: 6).repeatForever(autoreverses: true), value: offsetY)
                )
                .onAppear { offsetY = -50 }

            ScrollView {
                VStack(spacing: 20) {
                    Image(systemName: "\(userData.progress.avatar).fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.purple)
                        .shadow(color: .purple.opacity(0.5), radius: 10)
                        .scaleEffect(1.1)
                        .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: UUID())

                    Picker("Avatar", selection: $selectedAvatar) {
                        Text("Ninja").tag("ninja")
                        Text("Athlete").tag("person")
                        Text("Warrior").tag("shield")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    .background(Color.black.opacity(0.2))
                    .cornerRadius(10)
                    .onChange(of: selectedAvatar) { newValue in
                        userData.progress.avatar = newValue
                    }

                    Text("Level: \(userData.progress.level)")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: .purple.opacity(0.3), radius: 5)

                    Text("Total Challenges Completed: \(userData.progress.totalChallengesCompleted)")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))

                    HStack(spacing: 20) {
                        CrystalView(name: "Strength", value: userData.progress.strength)
                        CrystalView(name: "Endurance", value: userData.progress.endurance)
                        CrystalView(name: "Speed", value: userData.progress.speed)
                    }
                    .padding()
                    .background(Color.black.opacity(0.2))
                    .cornerRadius(15)
                    .shadow(color: .purple.opacity(0.3), radius: 10)

                    Text("Badges")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.9))
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(userData.progress.badges, id: \.self) { badge in
                                Image(systemName: "star.fill")
                                    .foregroundColor(.purple)
                                    .frame(width: 40, height: 40)
                                    .overlay(Text(badge).font(.caption).foregroundColor(.white))
                                    .shadow(color: .purple.opacity(0.5), radius: 5)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 20)
            }
        }
        .navigationTitle("Profile")
    }
}
