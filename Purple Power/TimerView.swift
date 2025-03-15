import SwiftUI
import AVFoundation

struct TimerView: View {
    @State private var selectedMinutes = 0
    @State private var selectedSeconds = 30
    @State private var timeRemaining: Int = 0
    @State private var isRunning = false
    @State private var offsetY: CGFloat = 0
    @State private var audioPlayer: AVAudioPlayer?
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var totalTime: Int { selectedMinutes * 60 + selectedSeconds }

    var body: some View {
        ZStack {
            // Градиентный фон с анимацией
            LinearGradient(gradient: Gradient(colors: [Color.black, Color.purple.opacity(0.8), Color.indigo.opacity(0.5)]), startPoint: .top, endPoint: .bottomTrailing)
                .ignoresSafeArea()
                .overlay(
                    Circle()
                        .fill(Color.purple.opacity(0.2))
                        .frame(width: 300, height: 300)
                        .blur(radius: 50)
                        .offset(x: -100, y: -150 + offsetY)
                        .animation(.easeInOut(duration: 5).repeatForever(autoreverses: true), value: offsetY)
                )
                .onAppear { offsetY = 50 }

            VStack(spacing: 30) {
                // Заголовок
                Text("HIIT Timer")
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: .purple.opacity(0.5), radius: 5)

                // Круг таймера
                ZStack {
                    Circle()
                        .trim(from: 0, to: timeRemaining > 0 ? CGFloat(timeRemaining) / CGFloat(totalTime) : 1.0)
                        .stroke(Color.purple, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                        .frame(width: 220, height: 220)
                        .animation(.linear(duration: 1), value: timeRemaining)

                    Text(formatTime(timeRemaining))
                        .font(.system(size: 60, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(color: .purple.opacity(0.3), radius: 5)
                }
                .padding()

                // Выбор времени (показывается, когда таймер не запущен)
                if !isRunning && timeRemaining == 0 {
                    HStack(spacing: 20) {
                        Picker("Minutes", selection: $selectedMinutes) {
                            ForEach(0..<60) { Text("\($0) min").tag($0) }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(width: 100, height: 100)
                        .clipped()
                        .background(Color.black.opacity(0.2))
                        .cornerRadius(10)

                        Picker("Seconds", selection: $selectedSeconds) {
                            ForEach(0..<60) { Text("\($0) sec").tag($0) }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(width: 100, height: 100)
                        .clipped()
                        .background(Color.black.opacity(0.2))
                        .cornerRadius(10)
                    }
                    .transition(.opacity)
                }

                // Кнопка управления
                Button(isRunning ? "Pause" : "Start") {
                    if isRunning {
                        isRunning = false
                    } else {
                        if timeRemaining == 0 { timeRemaining = totalTime }
                        isRunning = true
                    }
                }
                .buttonStyle(PurpleButtonStyle())
                .scaleEffect(isRunning ? 1.1 : 1.0)
                .animation(.spring(), value: isRunning)
            }
        }
        .onReceive(timer) { _ in
            if isRunning && timeRemaining > 0 {
                timeRemaining -= 1
                if timeRemaining == 0 {
                    isRunning = false
                    playSound()
                }
            }
        }
        .onAppear {
            prepareSound()
        }
    }

    // Форматирование времени в MM:SS
    func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }

    // Подготовка звука
    func prepareSound() {
        if let soundURL = Bundle.main.url(forResource: "alarm", withExtension: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                audioPlayer?.prepareToPlay()
            } catch {
                print("Error loading sound: \(error)")
            }
        }
    }

    // Проигрывание звука
    func playSound() {
        audioPlayer?.play()
    }
}
