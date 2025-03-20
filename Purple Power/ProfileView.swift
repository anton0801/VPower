import SwiftUI
import FirebaseAuth

//struct ProfileView: View {
//    @ObservedObject var userData: UserData
//    @State private var selectedAvatar = "ninja"
//    @State private var offsetY: CGFloat = 0
//    @Binding var isLoggedIn: Bool // Привязка для управления состоянием входа
//    @Binding var isGuestMode: Bool // Привязка для гостевого режима
//    
//    var body: some View {
//        ZStack {
//            LinearGradient(gradient: Gradient(colors: [Color.purple.opacity(0.7), Color.black, Color.indigo.opacity(0.5)]), startPoint: .topLeading, endPoint: .bottomTrailing)
//                .ignoresSafeArea()
//                .overlay(
//                    Circle()
//                        .fill(Color.indigo.opacity(0.2))
//                        .frame(width: 400, height: 400)
//                        .blur(radius: 60)
//                        .offset(x: 100, y: 300 + offsetY)
//                        .animation(.easeInOut(duration: 6).repeatForever(autoreverses: true), value: offsetY)
//                )
//                .onAppear { offsetY = -50 }
//            
//            ScrollView {
//                VStack(spacing: 20) {
//                    Image(systemName: "\(userData.progress.avatar).fill")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 100, height: 100)
//                        .foregroundColor(.purple)
//                        .shadow(color: .purple.opacity(0.5), radius: 10)
//                        .scaleEffect(1.1)
//                        .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: UUID())
//                    
//                    Picker("Avatar", selection: $selectedAvatar) {
//                        Text("Ninja").tag("ninja")
//                        Text("Athlete").tag("person")
//                        Text("Warrior").tag("shield")
//                    }
//                    .pickerStyle(SegmentedPickerStyle())
//                    .padding()
//                    .background(Color.black.opacity(0.2))
//                    .cornerRadius(10)
//                    .onChange(of: selectedAvatar) { newValue in
//                        userData.progress.avatar = newValue
//                    }
//                    
//                    Text("Level: \(userData.progress.level)")
//                        .font(.system(size: 28, weight: .bold, design: .rounded))
//                        .foregroundColor(.white)
//                        .shadow(color: .purple.opacity(0.3), radius: 5)
//                    
//                    Text("Total Challenges Completed: \(userData.progress.totalChallengesCompleted)")
//                        .font(.subheadline)
//                        .foregroundColor(.white.opacity(0.8))
//                    
//                    HStack(spacing: 20) {
//                        CrystalView(name: "Strength", value: userData.progress.strength)
//                        CrystalView(name: "Endurance", value: userData.progress.endurance)
//                        CrystalView(name: "Speed", value: userData.progress.speed)
//                    }
//                    .padding()
//                    .background(Color.black.opacity(0.2))
//                    .cornerRadius(15)
//                    .shadow(color: .purple.opacity(0.3), radius: 10)
//                    
//                    Text("Badges")
//                        .font(.headline)
//                        .foregroundColor(.white.opacity(0.9))
//                    ScrollView(.horizontal, showsIndicators: false) {
//                        HStack(spacing: 15) {
//                            ForEach(userData.progress.badges, id: \.self) { badge in
//                                Image(systemName: "star.fill")
//                                    .foregroundColor(.purple)
//                                    .frame(width: 40, height: 40)
//                                    .overlay(Text(badge).font(.caption).foregroundColor(.white))
//                                    .shadow(color: .purple.opacity(0.5), radius: 5)
//                            }
//                        }
//                    }
//                    .padding(.horizontal)
//                    
//                    Spacer()
//                    
//                    VStack(spacing: 15) {
//                        Button("Sign Out") {
//                            signOut()
//                        }
//                        .buttonStyle(PurpleButtonStyle())
//                        .shadow(color: .purple.opacity(0.5), radius: 5)
//
//                        Button("Remove Account") {
//                            removeAccount()
//                        }
//                        .buttonStyle(DestructiveButtonStyle())
//                        .shadow(color: .red.opacity(0.5), radius: 5)
//                    }
//                    .padding(.top, 20)
//                }
//                .padding(.vertical, 20)
//            }
//        }
//        .navigationTitle("Profile")
//    }
//    
//    // Выход из аккаунта
//    func signOut() {
//        do {
//            try Auth.auth().signOut()
//            isLoggedIn = false
//            isGuestMode = false
//            userData.progress = UserProgress() // Сброс прогресса (опционально)
//            userData.challenges = UserData().challenges // Сброс челленджей (опционально)
//        } catch {
//            print("Sign out error: \(error.localizedDescription)")
//        }
//    }
//    
//    // Удаление аккаунта
//    func removeAccount() {
//        if let user = Auth.auth().currentUser {
//            user.delete { error in
//                if let error = error {
//                    print("Remove account error: \(error.localizedDescription)")
//                } else {
//                    isLoggedIn = false
//                    isGuestMode = false
//                    userData.progress = UserProgress() // Сброс прогресса
//                    userData.challenges = UserData().challenges // Сброс челленджей
//                }
//            }
//        }
//    }
//    
//}

struct DestructiveButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, 12)
            .padding(.horizontal, 40)
            .background(LinearGradient(gradient: Gradient(colors: [.red.opacity(0.8), .black]), startPoint: .leading, endPoint: .trailing))
            .foregroundColor(.white)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

struct ProfileView: View {
    @ObservedObject var userData: UserData
    @State private var selectedAvatar = "ninja"
    @State private var offsetY: CGFloat = 0
    @State private var selectedCrystalColor: Color = .purple
    @Binding var isLoggedIn: Bool
    @Binding var isGuestMode: Bool
    @AppStorage("selectedTheme") var selectedTheme: String = "Neon Purple" // Сохраняем тему

    let allBadges = ["marathon", "strength", "plank", "journey", "sprint", "speed", "endurance", "power", "winter", "spring"]
    var totalSteps: Int { userData.progress.steps + 50000 }
    var averageSteps: Int { totalSteps / 30 }
    let monthlySteps: [Int] = [8000, 9500, 7000, 12000, 6000, 11000, 9000, 8500, 10000, 13000] // Пример данных

    var themeGradient: Gradient {
        switch selectedTheme {
        case "Neon Blue": return Gradient(colors: [Color.blue.opacity(0.9), Color.black, Color.cyan.opacity(0.7)])
        case "Dark Emerald": return Gradient(colors: [Color.green.opacity(0.9), Color.black, Color.teal.opacity(0.7)])
        default: return Gradient(colors: [Color.purple.opacity(0.9), Color.black, Color.indigo.opacity(0.7)])
        }
    }

    var body: some View {
        ZStack {
            LinearGradient(gradient: themeGradient, startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
                .overlay(
                    Circle()
                        .fill(selectedCrystalColor.opacity(0.2))
                        .frame(width: 400, height: 400)
                        .blur(radius: 60)
                        .offset(x: 100, y: 300 + offsetY)
                        .animation(.easeInOut(duration: 6).repeatForever(autoreverses: true), value: offsetY)
                )
                .onAppear { offsetY = -50 }

            ScrollView {
                VStack(spacing: 20) {
                    Image(systemName: "\(selectedAvatar).fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(selectedCrystalColor)
                        .shadow(color: selectedCrystalColor.opacity(0.5), radius: 10)
                        .scaleEffect(1.1)
                        .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: UUID())

                    Picker("Avatar", selection: $selectedAvatar) {
                        Text("Ninja").tag("ninja")
                        Text("Athlete").tag("person")
                        Text("Warrior").tag("shield")
                        Text("Mage").tag("wand.and.stars")
                        Text("Knight").tag("shield.checkered")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    .background(Color.black.opacity(0.2))
                    .cornerRadius(10)
                    .onChange(of: selectedAvatar) { userData.progress.avatar = $0 }

                    HStack {
                        Text("Theme colors:")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .shadow(color: selectedCrystalColor.opacity(0.3), radius: 5)
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    Picker("Crystal Color", selection: $selectedCrystalColor) {
                        Text("Purple").tag(Color.purple)
                        Text("Blue").tag(Color.blue)
                        Text("Green").tag(Color.green)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    .background(Color.black.opacity(0.2))
                    .cornerRadius(10)

                    Picker("Theme", selection: $selectedTheme) {
                        Text("Neon Purple").tag("Neon Purple")
                        Text("Neon Blue").tag("Neon Blue")
                        Text("Dark Emerald").tag("Dark Emerald")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    .background(Color.black.opacity(0.2))
                    .cornerRadius(10)

                    Text("Level: \(userData.progress.level)")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: selectedCrystalColor.opacity(0.3), radius: 5)

                    VStack(spacing: 10) {
                        Text("Total Steps: \(totalSteps)")
                        Text("Avg. Daily Steps: \(averageSteps)")
                        Text("Challenges Completed: \(userData.progress.totalChallengesCompleted)")
                    }
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))

                    HStack(spacing: 20) { CrystalView(name: "Strength", value: userData.progress.strength); CrystalView(name: "Endurance", value: userData.progress.endurance); CrystalView(name: "Speed", value: userData.progress.speed) }
                        .padding()
                        .background(Color.black.opacity(0.2))
                        .cornerRadius(15)
                        .shadow(color: selectedCrystalColor.opacity(0.3), radius: 10)

                    DashboardCard(title: "Monthly Progress", subtitle: "Steps over 30 days") {
                        WaveGraph(steps: monthlySteps, offset: 0)
                            .frame(height: 120)
                    }

                    DashboardCard(title: "Export Stats", subtitle: "Share your power") {
                        Button("Export as Image") {
                            // Логика экспорта (пока заглушка)
                        }
                        .buttonStyle(NeonButtonStyle())
                    }

                    Text("Badges (\(userData.progress.badges.count)/\(allBadges.count))")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.9))
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(allBadges, id: \.self) { badge in
                                Image(systemName: "star.fill")
                                    .foregroundColor(userData.progress.badges.contains(badge) ? selectedCrystalColor : .gray)
                                    .frame(width: 40, height: 40)
                                    .overlay(Text(badge).font(.caption).foregroundColor(.white))
                                    .shadow(color: selectedCrystalColor.opacity(0.5), radius: 5)
                            }
                        }
                    }
                    .padding(.horizontal)

                    VStack(spacing: 15) {
                        Button("Sign Out") { signOut() }
                            .buttonStyle(NeonButtonStyle())
                            .shadow(color: .purple.opacity(0.5), radius: 5)
                        Button("Remove Account") { removeAccount() }
                            .buttonStyle(DestructiveButtonStyle())
                            .shadow(color: .red.opacity(0.5), radius: 5)
                    }
                    .padding(.top, 20)
                }
                .padding(.vertical, 20)
            }
        }
        .navigationTitle("Profile")
    }

    // Выход из аккаунта
    func signOut() {
        do {
            try Auth.auth().signOut()
            isLoggedIn = false
            isGuestMode = false
            userData.progress = UserProgress() // Сброс прогресса (опционально)
            userData.challenges = UserData().challenges // Сброс челленджей (опционально)
        } catch {
            print("Sign out error: \(error.localizedDescription)")
        }
    }
    
    // Удаление аккаунта
    func removeAccount() {
        if let user = Auth.auth().currentUser {
            user.delete { error in
                if let error = error {
                    print("Remove account error: \(error.localizedDescription)")
                } else {
                    isLoggedIn = false
                    isGuestMode = false
                    userData.progress = UserProgress() // Сброс прогресса
                    userData.challenges = UserData().challenges // Сброс челленджей
                }
            }
        }
    }
    
}
