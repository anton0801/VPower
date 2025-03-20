import SwiftUI
import Lottie

//struct DashboardView: View {
//    @ObservedObject var userData: UserData
//    @State private var pulseAnimation = false
//    @State private var offsetY: CGFloat = 0
//
//    var body: some View {
//        NavigationView {
//            ZStack {
//                // Градиентный фон с анимацией
//                LinearGradient(gradient: Gradient(colors: [Color.purple.opacity(0.8), Color.black, Color.indigo.opacity(0.6)]), startPoint: .topLeading, endPoint: .bottomTrailing)
//                    .ignoresSafeArea()
//                    .overlay(
//                        Circle()
//                            .fill(Color.purple.opacity(0.2))
//                            .frame(width: 300, height: 300)
//                            .blur(radius: 50)
//                            .offset(x: -150, y: -200 + offsetY)
//                            .animation(.easeInOut(duration: 5).repeatForever(autoreverses: true), value: offsetY)
//                    )
//                    .onAppear { offsetY = 50 }
//
//                VStack(spacing: 20) {
//                    // Шаги
//                    Text("Steps: \(userData.progress.steps)")
//                        .font(.system(size: 40, weight: .bold, design: .rounded))
//                        .foregroundColor(.white)
//                        .shadow(color: .purple.opacity(0.5), radius: 5)
//                        .scaleEffect(pulseAnimation ? 1.1 : 1.0)
//                        .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: pulseAnimation)
//                        .onAppear { pulseAnimation = true }
//
//                    // Кристаллы
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
//                    // Текущий челлендж
//                    VStack(spacing: 10) {
//                        Text("Current Challenge")
//                            .font(.headline)
//                            .foregroundColor(.white.opacity(0.9))
//                        if let challenge = userData.challenges.first(where: { !$0.isCompleted }) {
//                            ChallengeCard(challenge: challenge)
//                                .transition(.scale)
//                        }
//                    }
//                    .padding()
//                    .background(Color.black.opacity(0.15))
//                    .cornerRadius(15)
//                    .shadow(color: .indigo.opacity(0.3), radius: 10)
//
//                    Spacer()
//                }
//                .padding(.top, 20)
//            }
//            .navigationTitle("Purple Power")
//        }
//    }
//}

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

struct DashboardView: View {
    @ObservedObject var userData: UserData
    @State private var pulseAnimation = false
    @State private var offsetY: CGFloat = 0
    @State private var dailyGoal: Int = UserDefaults.standard.integer(forKey: "DailyGoal") > 0 ? UserDefaults.standard.integer(forKey: "DailyGoal") : 10000
    @State private var showAchievement = false
    @State private var weeklySteps: [Int] = [8000, 9500, 7000, 12000, 6000, 11000, 9000] // Пример данных
    @State private var waveOffset: CGFloat = 0

    var body: some View {
        NavigationView {
            ZStack {
                // Градиентный фон с анимацией
                LinearGradient(gradient: Gradient(colors: [Color.purple.opacity(0.9), Color.black, Color.indigo.opacity(0.7)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                    .overlay(
                        Circle()
                            .fill(Color.purple.opacity(0.3))
                            .frame(width: 350, height: 350)
                            .blur(radius: 60)
                            .offset(x: -150, y: -200 + offsetY)
                            .animation(.easeInOut(duration: 5).repeatForever(autoreverses: true), value: offsetY)
                    )
                    .overlay(
                        Circle()
                            .fill(Color.indigo.opacity(0.2))
                            .frame(width: 400, height: 400)
                            .blur(radius: 80)
                            .offset(x: 150, y: 300 + offsetY)
                            .animation(.easeInOut(duration: 6).repeatForever(autoreverses: true), value: offsetY)
                    )
                    .onAppear { offsetY = 50 }

                // Анимация достижения
                if showAchievement {
                    LottieView(animationName: "lightning")
                        .frame(width: 250, height: 250)
                        .transition(.opacity)
                        .onAppear { DispatchQueue.main.asyncAfter(deadline: .now() + 2) { showAchievement = false } }
                }

                ScrollView {
                    VStack(spacing: 25) {
                        // Шаги с неоновым эффектом
                        ZStack {
                            Text("Steps")
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .foregroundColor(.white.opacity(0.5))
                                .offset(y: -30)
                            Text("\(userData.progress.steps)")
                                .font(.system(size: 60, weight: .black, design: .rounded))
                                .foregroundColor(.white)
                                .shadow(color: .purple.opacity(0.8), radius: 10, x: 0, y: 0)
                                .scaleEffect(pulseAnimation ? 1.05 : 1.0)
                                .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: pulseAnimation)
                                .onAppear { pulseAnimation = true }
                                .padding(.top, 12)
                        }
                        .padding(.top, 20)

                        // Дневная цель с кастомным прогресс-баром
                        DashboardCard(title: "Daily Goal", subtitle: "\(dailyGoal) steps") {
                            NeumorphicProgressView(progress: Float(min(userData.progress.steps, dailyGoal)) / Float(dailyGoal))
                            Picker("Set Goal", selection: $dailyGoal) {
                                ForEach([5000, 7500, 10000, 15000], id: \.self) { Text("\($0)").tag($0) }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .background(Color.black.opacity(0.3))
                            .cornerRadius(10)
                            .shadow(color: .purple.opacity(0.2), radius: 5)
                            .onChange(of: dailyGoal) { UserDefaults.standard.set($0, forKey: "DailyGoal") }
                        }

                        // Статистика за неделю с волнами
                        DashboardCard(title: "Weekly Stats", subtitle: "Your 7-day journey") {
                            WaveGraph(steps: weeklySteps, offset: waveOffset)
                                .frame(height: 120)
                                .onAppear {
                                    withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                                        waveOffset = 50
                                    }
                                }
                        }

                        // Кристаллы в неоновых карточках
                        HStack(spacing: 15) {
                            CrystalCard(name: "Strength", value: userData.progress.strength)
                            CrystalCard(name: "Endurance", value: userData.progress.endurance)
                            CrystalCard(name: "Speed", value: userData.progress.speed)
                        }

                        // Текущий челлендж
                        if let challenge = userData.challenges.first(where: { !$0.isCompleted }) {
                            DashboardCard(title: "Current Challenge", subtitle: challenge.name) {
                                ChallengeCard(challenge: challenge)
                                    .transition(.scale)
                                    .onChange(of: challenge.isCompleted) { if $0 { showAchievement = true } }
                            }
                        }
                    }
                    .padding(.vertical, 20)
                    .padding(.horizontal, 10)
                }
            }
            .navigationTitle("Home Power")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: ProfileView(userData: userData, isLoggedIn: .constant(true), isGuestMode: .constant(false))) {
                        Image(systemName: "person.circle.fill")
                            .foregroundColor(.white)
                            .scaleEffect(1.2)
                            .shadow(color: .purple.opacity(0.5), radius: 5)
                    }
                }
            }
        }
    }
}

struct WeeklyStepsGraph: View {
    let steps: [Int]

    var body: some View {
        HStack(spacing: 5) {
            ForEach(steps, id: \.self) { step in
                VStack {
                    Rectangle()
                        .fill(Color.purple)
                        .frame(width: 20, height: CGFloat(step) / 200)
                        .cornerRadius(5)
                    Text("\(step / 1000)k")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }
            }
        }
        .frame(height: 100)
    }
}

struct DashboardCard<Content: View>: View {
    let title: String
    let subtitle: String
    let content: Content

    init(title: String, subtitle: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.subtitle = subtitle
        self.content = content()
    }

    var body: some View {
        VStack(spacing: 10) {
            Text(title)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .shadow(color: .purple.opacity(0.3), radius: 5)
            Text(subtitle)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.7))
            content
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.black.opacity(0.2))
                .shadow(color: .purple.opacity(0.4), radius: 10, x: 0, y: 5)
        )
    }
}

struct NeumorphicProgressView: View {
    let progress: Float

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.black.opacity(0.3))
                    .frame(height: 20)
                    .shadow(color: .black.opacity(0.3), radius: 5, x: 2, y: 2)
                    .shadow(color: .white.opacity(0.1), radius: 5, x: -2, y: -2)

                RoundedRectangle(cornerRadius: 10)
                    .fill(LinearGradient(gradient: Gradient(colors: [.purple, .indigo]), startPoint: .leading, endPoint: .trailing))
                    .frame(width: geometry.size.width * CGFloat(progress), height: 20)
                    .shadow(color: .purple.opacity(0.5), radius: 5)
            }
        }
        .frame(height: 20)
    }
}

struct WaveGraph: View {
    let steps: [Int]
    let offset: CGFloat

    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let width = geometry.size.width / CGFloat(steps.count - 1)
                let maxHeight = geometry.size.height
                let maxSteps = CGFloat(steps.max() ?? 10000) * 1.2

                path.move(to: CGPoint(x: 0, y: maxHeight))
                for (index, step) in steps.enumerated() {
                    let x = CGFloat(index) * width
                    let y = maxHeight - (CGFloat(step) / maxSteps * maxHeight)
                    path.addQuadCurve(to: CGPoint(x: x, y: y), control: CGPoint(x: x - width / 2, y: y))
                }
                path.addLine(to: CGPoint(x: geometry.size.width, y: maxHeight))
                path.closeSubpath()
            }
            .fill(LinearGradient(gradient: Gradient(colors: [.purple.opacity(0.5), .indigo.opacity(0.3)]), startPoint: .top, endPoint: .bottom))
            .offset(x: -offset)
        }
    }
}

struct CrystalCard: View {
    let name: String
    let value: Int
    @State private var isAnimating = false

    var body: some View {
        VStack(spacing: 5) {
            Image(systemName: "hexagon.fill")
                .foregroundColor(.purple)
                .scaleEffect(isAnimating ? 1.2 : 1.0)
                .animation(.spring(response: 0.5, dampingFraction: 0.6).repeatForever(autoreverses: true), value: isAnimating)
                .shadow(color: .purple.opacity(0.7), radius: 5)
            Text("\(value)")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            Text(name)
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
        }
        .padding()
        .frame(width: 100)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.black.opacity(0.25))
                .shadow(color: .purple.opacity(0.4), radius: 8, x: 0, y: 4)
        )
        .onAppear { isAnimating = true }
    }
}
