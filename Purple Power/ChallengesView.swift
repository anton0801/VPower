import SwiftUI

//struct ChallengesView: View {
//    @ObservedObject var userData: UserData
//    @State private var offsetY: CGFloat = 0
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
//                VStack(spacing: 15) {
//                    Text("Challenges")
//                        .font(.system(size: 30, weight: .bold, design: .rounded))
//                        .foregroundColor(.white)
//                        .padding(.top, 20)
//                        .shadow(color: .purple.opacity(0.5), radius: 5)
//
//                    ForEach(userData.challenges) { challenge in
//                        ChallengeCard(challenge: challenge)
//                            .scaleEffect(challenge.isCompleted ? 0.95 : 1.0)
//                            .animation(.spring(), value: challenge.isCompleted)
//                    }
//                }
//                .padding()
//            }
//        }
//        .navigationTitle("Challenges")
//    }
//}
//
//struct ChallengeCard: View {
//    let challenge: Challenge
//    @State private var isHovered = false
//
//    var body: some View {
//        HStack {
//            VStack(alignment: .leading, spacing: 5) {
//                Text(challenge.name)
//                    .font(.headline)
//                    .foregroundColor(.white)
//                Text(challenge.description)
//                    .font(.subheadline)
//                    .foregroundColor(.white.opacity(0.7))
//                ProgressView(value: Float(challenge.progress), total: Float(challenge.goal))
//                    .tint(.purple)
//                    .scaleEffect(1.2)
//                Text("Reward: \(challenge.reward.strength)S, \(challenge.reward.endurance)E, \(challenge.reward.speed)Sp")
//                    .font(.caption)
//                    .foregroundColor(.white.opacity(0.8))
//            }
//            Spacer()
//            Image(systemName: challenge.isCompleted ? "checkmark.circle.fill" : "circle")
//                .foregroundColor(.purple)
//                .scaleEffect(isHovered ? 1.2 : 1.0)
//        }
//        .padding()
//        .background(Color.black.opacity(0.2))
//        .cornerRadius(15)
//        .shadow(color: .purple.opacity(0.3), radius: 10)
//        .scaleEffect(isHovered ? 1.02 : 1.0)
//        .animation(.easeInOut(duration: 0.2), value: isHovered)
//        .onHover { hovering in isHovered = hovering }
//    }
//}

struct ChallengesView: View {
    @ObservedObject var userData: UserData
    @State private var offsetY: CGFloat = 0
    @State private var selectedCategory: String = "Steps"

    var filteredChallenges: [Challenge] {
        userData.challenges.filter { $0.type == selectedCategory.lowercased() || ($0.type == "multi" && selectedCategory == "Multi-Stage") }
    }

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

            VStack(spacing: 20) {
                Text("Challenges")
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: .purple.opacity(0.5), radius: 5)

                Picker("Category", selection: $selectedCategory) {
                    Text("Steps").tag("Steps")
                    Text("Strength").tag("Strength")
                    Text("Endurance").tag("Endurance")
                    Text("Multi-Stage").tag("Multi-Stage")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                .background(Color.black.opacity(0.2))
                .cornerRadius(10)

                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(filteredChallenges) { challenge in
                            ChallengeCard(challenge: challenge)
                                .scaleEffect(challenge.isCompleted ? 0.95 : 1.0)
                                .animation(.spring(), value: challenge.isCompleted)
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Challenges")
    }
}

//struct ChallengeCard: View {
//    let challenge: Challenge
//    @State private var isHovered = false
//
//    var body: some View {
//        HStack {
//            VStack(alignment: .leading, spacing: 5) {
//                Text(challenge.name)
//                    .font(.headline)
//                    .foregroundColor(.white)
//                Text(challenge.description)
//                    .font(.subheadline)
//                    .foregroundColor(.white.opacity(0.7))
//                ProgressView(value: Float(challenge.progress), total: Float(challenge.goal))
//                    .tint(.purple)
//                    .scaleEffect(1.2)
//                Text("Reward: \(challenge.reward.strength)S, \(challenge.reward.endurance)E, \(challenge.reward.speed)Sp")
//                    .font(.caption)
//                    .foregroundColor(.white.opacity(0.8))
//                if let deadline = challenge.deadline {
//                    Text("Ends: \(deadline, style: .date)")
//                        .font(.caption)
//                        .foregroundColor(.red.opacity(0.8))
//                }
//            }
//            Spacer()
//            Image(systemName: challenge.isCompleted ? "checkmark.circle.fill" : "circle")
//                .foregroundColor(.purple)
//                .scaleEffect(isHovered ? 1.2 : 1.0)
//        }
//        .padding()
//        .background(Color.black.opacity(0.2))
//        .cornerRadius(15)
//        .shadow(color: .purple.opacity(0.3), radius: 10)
//        .scaleEffect(isHovered ? 1.02 : 1.0)
//        .animation(.easeInOut(duration: 0.2), value: isHovered)
//        .onHover { hovering in isHovered = hovering }
//    }
//}

struct ChallengeCard: View {
    let challenge: Challenge
    @State private var isHovered = false

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(challenge.name)
                    .font(.headline)
                    .foregroundColor(.white)
                Text(challenge.description)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
                if challenge.type == "multi" {
                    ForEach(0..<challenge.goal, id: \.self) { stage in
                        ProgressView(value: Float(min(challenge.progress, stage + 1)), total: Float(stage + 1))
                            .tint(.purple)
                            .scaleEffect(1.1)
                    }
                } else {
                    ProgressView(value: Float(challenge.progress), total: Float(challenge.goal))
                        .tint(.purple)
                        .scaleEffect(1.2)
                }
                Text("Reward: \(challenge.reward.strength)S, \(challenge.reward.endurance)E, \(challenge.reward.speed)Sp")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
                if let deadline = challenge.deadline {
                    Text("Ends: \(deadline, style: .date)")
                        .font(.caption)
                        .foregroundColor(.red.opacity(0.8))
                }
            }
            Spacer()
            Image(systemName: challenge.isCompleted ? "checkmark.circle.fill" : "circle")
                .foregroundColor(.purple)
                .scaleEffect(isHovered ? 1.2 : 1.0)
        }
        .padding()
        .background(Color.black.opacity(0.2))
        .cornerRadius(15)
        .shadow(color: .purple.opacity(0.3), radius: 10)
        .scaleEffect(isHovered ? 1.02 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isHovered)
        .onHover { hovering in isHovered = hovering }
    }
}
