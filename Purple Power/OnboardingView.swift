import SwiftUI
import Lottie

struct OnboardingView: View {
    @State private var currentPage = 0
    @Binding var isOnboardingCompleted: Bool

    let pages = [
        ("Welcome to V: Power", "Track your steps and conquer challenges!", "welcome"),
        ("Challenges Await", "Complete missions to earn rewards and badges.", "challenge"),
        ("Level Up", "Build strength, endurance, and speed with every step.", "levelup")
    ]

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.purple.opacity(0.8), Color.black, Color.indigo.opacity(0.6)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                            .ignoresSafeArea()
                            .overlay(
                                Circle()
                                    .fill(Color.purple.opacity(0.2))
                                    .frame(width: 300, height: 300)
                                    .blur(radius: 50)
                                    .offset(x: -150, y: -200)
                                    .animation(.easeInOut(duration: 5).repeatForever(autoreverses: true), value: UUID())
                            )

            VStack {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPage(title: pages[index].0, subtitle: pages[index].1, animationName: pages[index].2)
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle())
                .animation(.easeInOut, value: currentPage)

                Button(currentPage == pages.count - 1 ? "Get Started" : "Next") {
                    withAnimation {
                        if currentPage < pages.count - 1 {
                            currentPage += 1
                        } else {
                            isOnboardingCompleted = true
                        }
                    }
                }
                .buttonStyle(PurpleButtonStyle())
                .padding()
            }
        }
    }
}

struct OnboardingPage: View {
    let title: String
    let subtitle: String
    let animationName: String

    var body: some View {
        VStack(spacing: 20) {
            LottieView(animationName: animationName)
                .frame(width: 300, height: 300)
            Text(title)
                .font(.title)
                .foregroundColor(.white)
            Text(subtitle)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
        }
    }
}

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
