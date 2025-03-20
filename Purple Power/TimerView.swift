import SwiftUI
import AVFoundation

struct TimerView: View {
    @State private var selectedMinutes = 0
    @State private var selectedSeconds = 30
    @State private var timeRemaining: Int = 0
    @State private var restTimeRemaining: Int = 0
    @State private var isRunning = false
    @State private var isResting = false
    @State private var offsetY: CGFloat = 0
    @State private var shakeOffset: CGFloat = 0
    @State private var selectedSound = "bell"
    @State private var audioPlayer: AVAudioPlayer?
    @State private var glowPulse = false
    @AppStorage("selectedTheme") var selectedTheme: String = "Neon Purple"
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let presets = [("Tabata", 20, 10, 8), ("Sprint", 30, 15, 6)]

    var totalTime: Int { selectedMinutes * 60 + selectedSeconds }
    var themeGradient: Gradient {
        switch selectedTheme {
        case "Neon Blue": return Gradient(colors: [Color.blue.opacity(0.9), Color.black, Color.cyan.opacity(0.7)])
        case "Dark Emerald": return Gradient(colors: [Color.green.opacity(0.9), Color.black, Color.teal.opacity(0.7)])
        default: return Gradient(colors: [Color.purple.opacity(0.9), Color.black, Color.indigo.opacity(0.7)])
        }
    }

    var body: some View {
        ZStack {
            LinearGradient(gradient: themeGradient, startPoint: .top, endPoint: .bottomTrailing)
                .ignoresSafeArea()
                .overlay(
                    Circle()
                        .fill(themeColor.opacity(0.3))
                        .frame(width: 350, height: 350)
                        .blur(radius: 60)
                        .offset(x: -150, y: -200 + offsetY)
                        .animation(.easeInOut(duration: 5).repeatForever(autoreverses: true), value: offsetY)
                )
                .overlay(
                    Color.black.opacity(isResting ? 0.3 : 0.0)
                        .animation(.easeInOut(duration: 0.5), value: isResting)
                )
                .onAppear { offsetY = 50 }

            ScrollView(showsIndicators: false) {
                VStack(spacing: 30) {
                    Text(isResting ? "Rest" : "HIIT Timer")
                        .font(.system(size: 34, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: themeColor.opacity(0.8), radius: 10)

                    ZStack {
                        Circle()
                            .fill(Color.black.opacity(0.3))
                            .frame(width: 260, height: 260)
                            .shadow(color: themeColor.opacity(0.5), radius: 15)

                        Circle()
                            .trim(from: 0, to: isResting ? CGFloat(restTimeRemaining) / CGFloat(presets.first(where: { $0.0 == "Tabata" })?.2 ?? 10) : CGFloat(timeRemaining) / CGFloat(totalTime))
                            .stroke(LinearGradient(gradient: Gradient(colors: [themeColor, .indigo]), startPoint: .topLeading, endPoint: .bottomTrailing), style: StrokeStyle(lineWidth: 16, lineCap: .round))
                            .rotationEffect(.degrees(-90))
                            .frame(width: 240, height: 240)
                            .shadow(color: themeColor.opacity(glowPulse ? 0.8 : 0.4), radius: 20)
                            .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: glowPulse)
                            .animation(.linear(duration: 1), value: timeRemaining)
                            .onAppear { glowPulse = true }

                        Text(isResting ? formatTime(restTimeRemaining) : formatTime(timeRemaining))
                            .font(.system(size: 70, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .shadow(color: themeColor.opacity(0.5), radius: 5)
                    }
                    .offset(x: shakeOffset)
                    .animation(.spring(response: 0.1, dampingFraction: 0.2).repeatCount(3), value: shakeOffset)

                    if !isRunning && timeRemaining == 0 && !isResting {
                        DashboardCard(title: "Set Timer", subtitle: "Custom or Preset") {
                            HStack(spacing: 20) {
                                Picker("Minutes", selection: $selectedMinutes) { ForEach(0..<60) { Text("\($0) min").tag($0) } }
                                    .pickerStyle(WheelPickerStyle())
                                    .frame(width: 100, height: 100)
                                    .clipped()
                                    .background(Color.black.opacity(0.3))
                                    .cornerRadius(10)

                                Picker("Seconds", selection: $selectedSeconds) { ForEach(0..<60) { Text("\($0) sec").tag($0) } }
                                    .pickerStyle(WheelPickerStyle())
                                    .frame(width: 100, height: 100)
                                    .clipped()
                                    .background(Color.black.opacity(0.3))
                                    .cornerRadius(10)
                            }
                            HStack(spacing: 15) {
                                ForEach(presets, id: \.0) { preset in
                                    Button(preset.0) {
                                        selectedMinutes = 0
                                        selectedSeconds = preset.1
                                        restTimeRemaining = preset.2
                                    }
                                    .buttonStyle(NeonButtonStyle())
                                    .scaleEffect(0.9)
                                }
                            }
                        }
                    }

                    DashboardCard(title: "End Sound", subtitle: "Pick your vibe") {
                        Picker("Sound", selection: $selectedSound) {
                            Text("Bell").tag("bell")
                            Text("Siren").tag("siren")
                            Text("Clap").tag("clap")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .background(Color.black.opacity(0.3))
                        .cornerRadius(10)
                        .frame(width: 220)
                    }

                    Button(isRunning ? "Pause" : "Start") {
                        if isRunning {
                            isRunning = false
                        } else {
                            if timeRemaining == 0 { timeRemaining = totalTime }
                            isRunning = true
                        }
                    }
                    .buttonStyle(NeonButtonStyle())
                    .scaleEffect(isRunning ? 1.1 : 1.0)
                    .animation(.spring(), value: isRunning)
                    .padding(.bottom, 20)
                }
                .padding(.horizontal, 10)
            }
        }
        .onReceive(timer) { _ in
            if isRunning {
                if isResting {
                    if restTimeRemaining > 0 {
                        restTimeRemaining -= 1
                    } else {
                        isResting = false
                        timeRemaining = totalTime
                    }
                } else if timeRemaining > 0 {
                    timeRemaining -= 1
                    if timeRemaining == 0 {
                        if selectedSeconds == presets.first(where: { $0.0 == "Tabata" })?.1 {
                            isResting = true
                            restTimeRemaining = presets.first(where: { $0.0 == "Tabata" })?.2 ?? 10
                        } else {
                            playSound()
                            shakeOffset = 10
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { shakeOffset = 0 }
                        }
                    }
                }
            }
        }
        .onAppear { prepareSound() }
    }

    func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }

    func prepareSound() {
        if let soundURL = Bundle.main.url(forResource: selectedSound, withExtension: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                audioPlayer?.prepareToPlay()
            } catch {
                print("Error loading sound: \(error)")
            }
        }
    }

    func playSound() {
        prepareSound()
        audioPlayer?.play()
    }

    var themeColor: Color {
        switch selectedTheme {
        case "Neon Blue": return .blue
        case "Dark Emerald": return .green
        default: return .purple
        }
    }
}

// Неоновый стиль кнопок
struct NeonButtonStyle: ButtonStyle {
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
