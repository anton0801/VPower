import SwiftUI
import Lottie
import AVFoundation

//struct OnboardingView: View {
//    @State private var currentPage = 0
//    @Binding var isOnboardingCompleted: Bool
//
//    let pages = [
//        ("Welcome to V: Power", "Track your steps and conquer challenges!", "welcome"),
//        ("Challenges Await", "Complete missions to earn rewards and badges.", "challenge"),
//        ("Level Up", "Build strength, endurance, and speed with every step.", "levelup")
//    ]
//
//    var body: some View {
//        ZStack {
//            LinearGradient(gradient: Gradient(colors: [Color.purple.opacity(0.8), Color.black, Color.indigo.opacity(0.6)]), startPoint: .topLeading, endPoint: .bottomTrailing)
//                            .ignoresSafeArea()
//                            .overlay(
//                                Circle()
//                                    .fill(Color.purple.opacity(0.2))
//                                    .frame(width: 300, height: 300)
//                                    .blur(radius: 50)
//                                    .offset(x: -150, y: -200)
//                                    .animation(.easeInOut(duration: 5).repeatForever(autoreverses: true), value: UUID())
//                            )
//
//            VStack {
//                TabView(selection: $currentPage) {
//                    ForEach(0..<pages.count, id: \.self) { index in
//                        OnboardingPage(title: pages[index].0, subtitle: pages[index].1, animationName: pages[index].2)
//                            .tag(index)
//                    }
//                }
//                .tabViewStyle(PageTabViewStyle())
//                .animation(.easeInOut, value: currentPage)
//
//                Button(currentPage == pages.count - 1 ? "Get Started" : "Next") {
//                    withAnimation {
//                        if currentPage < pages.count - 1 {
//                            currentPage += 1
//                        } else {
//                            isOnboardingCompleted = true
//                        }
//                    }
//                }
//                .buttonStyle(PurpleButtonStyle())
//                .padding()
//            }
//        }
//    }
//}
//
//struct OnboardingPage: View {
//    let title: String
//    let subtitle: String
//    let animationName: String
//
//    var body: some View {
//        VStack(spacing: 20) {
//            LottieView(animationName: animationName)
//                .frame(width: 300, height: 300)
//            Text(title)
//                .font(.title)
//                .foregroundColor(.white)
//            Text(subtitle)
//                .font(.subheadline)
//                .foregroundColor(.white.opacity(0.8))
//                .multilineTextAlignment(.center)
//        }
//    }
//}

// Lottie View
struct LottieView: UIViewRepresentable {
    let animationName: String

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        let animationView = LottieAnimationView(name: animationName)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
        view.addSubview(animationView)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}


struct OnboardingView: View {
    @Binding var isOnboardingCompleted: Bool
    @State private var currentPage = 0
    @State private var offsetY: CGFloat = 0
    @State private var slideOffset: CGFloat = 0
    @State private var audioPlayer: AVAudioPlayer?
    @AppStorage("selectedTheme") var selectedTheme: String = "Neon Purple"
    var themeColor: Color {
        switch selectedTheme {
        case "Neon Blue": return .blue
        case "Dark Emerald": return .green
        default: return .purple
        }
    }

    let slides = [
        (title: "Welcome to V: Power", subtitle: "Track your steps and conquer challenges!", animation: "welcome"),
        (title: "Challenges Await", subtitle: "Complete missions to earn rewards and badges.", animation: "challenge"),
        (title: "Level Up", subtitle: "Build strength, endurance, and speed with every step.", animation: "levelup")
    ]
    
    var themeGradient: Gradient {
        switch selectedTheme {
        case "Neon Blue": return Gradient(colors: [Color.blue.opacity(0.9), Color.black, Color.cyan.opacity(0.7)])
        case "Dark Emerald": return Gradient(colors: [Color.green.opacity(0.9), Color.black, Color.teal.opacity(0.7)])
        default: return Gradient(colors: [Color.purple.opacity(0.9), Color.black, Color.indigo.opacity(0.7)])
        }
    }
    
    func prepareSounds() {
        if let clickURL = Bundle.main.url(forResource: "click", withExtension: "wav") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: clickURL)
                audioPlayer?.prepareToPlay()
            } catch {
                print("Error loading sound: \(error)")
            }
        }
    }
    
    func playClickSound() {
        if let clickURL = Bundle.main.url(forResource: "click", withExtension: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: clickURL)
                audioPlayer?.play()
            } catch {
                print("Error playing click: \(error)")
            }
        }
    }

    var body: some View {
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

            VStack(spacing: 30) {
                // Слайды
                TabView(selection: $currentPage) {
                    ForEach(0..<slides.count, id: \.self) { index in
                        VStack(spacing: 20) {
                            LottieView(animationName: slides[index].animation)
                                .frame(width: 200, height: 200)
                                .offset(y: slideOffset)
                                .animation(.spring(response: 0.5, dampingFraction: 0.7), value: slideOffset)

                            Text(slides[index].title)
                                .font(.system(size: 34, weight: .black, design: .rounded))
                                .foregroundColor(.white)
                                .shadow(color: .purple.opacity(0.8), radius: 10)

                            Text(slides[index].subtitle)
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.7))
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .frame(height: 400)
                .onChange(of: currentPage) { _ in
                    withAnimation { slideOffset = -20 }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { withAnimation { slideOffset = 0 } }
                    playClickSound()
                }
                .gesture(DragGesture()
                    .onEnded { value in
                        if value.translation.height < -100 { // Смахивание вверх
                            withAnimation { isOnboardingCompleted = true }
                            UserDefaults.standard.set(true, forKey: "OnboardingCompleted")
                        }
                    })

                // Индикаторы страниц
                HStack(spacing: 10) {
                    ForEach(0..<slides.count, id: \.self) { index in
                        Circle()
                            .fill(index == currentPage ? Color.purple : Color.white.opacity(0.3))
                            .frame(width: 10, height: 10)
                            .shadow(color: .purple.opacity(0.5), radius: 5)
                    }
                }

                // Кнопки
                if currentPage < slides.count - 1 {
                    Button("Next") {
                        withAnimation(.easeInOut) { currentPage += 1 }
                    }
                    .buttonStyle(NeonButtonStyleBoarding())
                } else {
                    Button("Get Started") {
                        withAnimation {
                            isOnboardingCompleted = true
                        }
                        UserDefaults.standard.set(true, forKey: "OnboardingCompleted")
                    }
                    .buttonStyle(NeonButtonStyleBoarding())
                }
            }
            .padding()
            .onAppear { prepareSounds() }
        }
    }
}

// Неоновый стиль кнопок (переиспользуем из TimerView)
struct NeonButtonStyleBoarding: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, 12)
            .padding(.horizontal, 40)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(LinearGradient(gradient: Gradient(colors: [.purple, .indigo]), startPoint: .leading, endPoint: .trailing))
                    .shadow(color: .purple.opacity(configuration.isPressed ? 0.3 : 0.7), radius: 10)
            )
            .foregroundColor(.white)
            .font(.system(size: 16, weight: .bold, design: .rounded))
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}
