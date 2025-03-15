import SwiftUI
import FirebaseAuth

struct RegisterView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var phoneNumber = ""
    @Binding var isLoggedIn: Bool
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            // Градиентный фон с эффектом
            LinearGradient(gradient: Gradient(colors: [Color.purple.opacity(0.7), Color.black, Color.indigo.opacity(0.5)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
                .overlay(
                    Circle()
                        .fill(Color.indigo.opacity(0.2))
                        .frame(width: 400, height: 400)
                        .blur(radius: 60)
                        .offset(x: 100, y: 300)
                        .animation(.easeInOut(duration: 6).repeatForever(autoreverses: true), value: UUID())
                )

            VStack(spacing: 25) {
                // Заголовок
                Text("Join Purple Power")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: .purple.opacity(0.5), radius: 10, x: 0, y: 5)

                // Поля ввода
                VStack(spacing: 15) {
                    TextField("Name", text: $name)
                        .textFieldStyle(CustomTextFieldStyle())

                    TextField("Email", text: $email)
                        .textFieldStyle(CustomTextFieldStyle())
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)

                    SecureField("Password", text: $password)
                        .textFieldStyle(CustomTextFieldStyle())

                    TextField("Phone Number", text: $phoneNumber)
                        .textFieldStyle(CustomTextFieldStyle())
                        .keyboardType(.phonePad)
                }
                .padding(.horizontal, 40)

                // Кнопка регистрации
                Button("Register") {
                    Auth.auth().createUser(withEmail: email, password: password) { result, error in
                        if error == nil {
                            isLoggedIn = true
                            dismiss()
                        } else {
                            print("Register error: \(error?.localizedDescription ?? "")")
                        }
                    }
                }
                .buttonStyle(PurpleButtonStyle())
                .padding(.top, 20)

                Button(action: { dismiss() }) {
                    Text("Already have an account? Login")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                        .underline()
                }
            }
            .padding()
        }
    }
}
