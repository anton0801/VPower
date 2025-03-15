import Foundation
import CoreMotion

struct UserProgress: Codable {
    var steps: Int = 0
    var strength: Int = 0
    var endurance: Int = 0
    var speed: Int = 0
    var level: Int = 1
    var avatar: String = "ninja"
    var badges: [String] = [] // Значки за достижения
    var totalChallengesCompleted: Int = 0
}

struct Challenge: Identifiable, Codable {
    let id = UUID()
    let name: String
    let description: String
    let goal: Int
    let type: String // "steps", "push-ups", "run"
    let reward: Reward
    var progress: Int = 0
    var isCompleted: Bool = false
}

struct Reward: Codable {
    let strength: Int
    let endurance: Int
    let speed: Int
    let badge: String?
}

class UserData: ObservableObject {
    @Published var progress: UserProgress {
        didSet { saveProgress() }
    }
    @Published var challenges: [Challenge] {
        didSet { saveChallenges() }
    }
    @Published var isLoggedIn: Bool = false
    private let pedometer = CMPedometer()

    init() {
        progress = UserDefaults.standard.load(key: "UserProgress") ?? UserProgress()
        challenges = UserDefaults.standard.load(key: "Challenges") ?? [
            Challenge(name: "Purple Marathon", description: "Run 10 km in a week", goal: 10000, type: "steps", reward: Reward(strength: 10, endurance: 5, speed: 5, badge: "marathon")),
            Challenge(name: "Amethyst Strength", description: "Complete 100 push-ups", goal: 100, type: "push-ups", reward: Reward(strength: 15, endurance: 0, speed: 0, badge: "strength")),
            Challenge(name: "Violet Sprint", description: "Run 5 km in one go", goal: 5000, type: "steps", reward: Reward(strength: 5, endurance: 5, speed: 10, badge: "sprint")),
            Challenge(name: "Winter Purple Run", description: "Run 15 km in cold weather", goal: 15000, type: "steps", reward: Reward(strength: 10, endurance: 10, speed: 5, badge: "winter")),
            Challenge(name: "Shadow Plank", description: "Hold a plank for 5 minutes", goal: 300, type: "seconds", reward: Reward(strength: 5, endurance: 15, speed: 0, badge: "plank"))
        ]
        startPedometerUpdates()
    }

    func saveProgress() { UserDefaults.standard.save(progress, key: "UserProgress") }
    func saveChallenges() { UserDefaults.standard.save(challenges, key: "Challenges") }

    func startPedometerUpdates() {
        if CMPedometer.isStepCountingAvailable() {
            pedometer.startUpdates(from: Date()) { [weak self] pedometerData, error in
                guard let self = self, let pedometerData = pedometerData, error == nil else { return }
                DispatchQueue.main.async {
                    self.progress.steps = pedometerData.numberOfSteps.intValue
                    self.updateChallenges()
                }
            }
        }
    }

    func updateChallenges() {
        for i in 0..<challenges.count {
            if challenges[i].type == "steps" {
                challenges[i].progress = min(challenges[i].goal, progress.steps)
                if challenges[i].progress >= challenges[i].goal && !challenges[i].isCompleted {
                    challenges[i].isCompleted = true
                    progress.strength += challenges[i].reward.strength
                    progress.endurance += challenges[i].reward.endurance
                    progress.speed += challenges[i].reward.speed
                    if let badge = challenges[i].reward.badge {
                        progress.badges.append(badge)
                    }
                    progress.totalChallengesCompleted += 1
                }
            }
        }
    }
}

extension UserDefaults {
    func save<T: Codable>(_ object: T, key: String) {
        if let encoded = try? JSONEncoder().encode(object) { set(encoded, forKey: key) }
    }
    func load<T: Codable>(key: String) -> T? {
        if let data = data(forKey: key), let decoded = try? JSONDecoder().decode(T.self, from: data) { return decoded }
        return nil
    }
}
