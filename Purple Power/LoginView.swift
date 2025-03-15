import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var showRegister = false
    @Binding var isLoggedIn: Bool
    @Binding var isGuestMode: Bool

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

            VStack(spacing: 25) {
                // Логотип или заголовок
                Text("Purple Power")
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: .purple.opacity(0.5), radius: 10, x: 0, y: 5)

                // Поля ввода
                VStack(spacing: 15) {
                    TextField("Email", text: $email)
                        .textFieldStyle(CustomTextFieldStyle())
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)

                    SecureField("Password", text: $password)
                        .textFieldStyle(CustomTextFieldStyle())
                }
                .padding(.horizontal, 40)

                // Кнопка логина
                Button("Login") {
                    if !email.isEmpty && !password.isEmpty {
                        Auth.auth().signIn(withEmail: email, password: password) { result, error in
                            if error == nil { isLoggedIn = true }
                        }
                    }
                }
                .buttonStyle(PurpleButtonStyle())
                .padding(.top, 20)

                // Кнопка регистрации
                Button(action: { withAnimation { showRegister = true } }) {
                    Text("Don't have an account? Register")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                        .underline()
                }

                // Гостевой режим
                Button(action: {
                    Auth.auth().signInAnonymously { result, error in
                        if error == nil {
                            isLoggedIn = true
                            isGuestMode = true
                        } else {
                            print("Guest login error: \(error?.localizedDescription ?? "")")
                        }
                    }
                }) {
                    Text("Continue as Guest")
                        .font(.footnote)
                        .foregroundColor(.white.opacity(0.6))
                        .padding(.top, 10)
                }
            }
            .padding()
        }
        .sheet(isPresented: $showRegister) {
            RegisterView(isLoggedIn: $isLoggedIn)
        }
    }
}

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color.black.opacity(0.2))
            .cornerRadius(10)
            .foregroundColor(.white)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.purple.opacity(0.5), lineWidth: 1))
    }
}

struct PurpleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, 12)
            .padding(.horizontal, 40)
            .background(LinearGradient(gradient: Gradient(colors: [.purple, .indigo]), startPoint: .leading, endPoint: .trailing))
            .foregroundColor(.white)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .shadow(color: .purple.opacity(0.5), radius: 5, x: 0, y: 5)
            .animation(.spring(), value: configuration.isPressed)
    }
}
