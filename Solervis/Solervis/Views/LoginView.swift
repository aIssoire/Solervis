import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String?
    @EnvironmentObject var userSettings: UserSettings

    var body: some View {
        VStack {
            Spacer()
            
            Image("solervis_logo") // Assurez-vous que l'image du logo est ajoutée à vos assets
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 100)
            
            Spacer()
            
            VStack(spacing: 20) {
                CustomTextField(placeholder: "E-Mail", imageName: "envelope", text: $email)
                    .padding()
                    .background(Color.yellow.opacity(0.3))
                    .cornerRadius(8)
                
                CustomTextField(placeholder: "Mot de passe", imageName: "lock", text: $password, isSecure: true)
                    .padding()
                    .background(Color.yellow.opacity(0.3))
                    .cornerRadius(8)
            }
            .padding(.horizontal, 32)
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            
            Button(action: {
                login()
            }) {
                Text("Connexion")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.orange)
                    .cornerRadius(8)
            }
            .padding(.horizontal, 32)
            .padding(.top, 20)
            
            Spacer()
            
            Button(action: {
                // Action pour s'inscrire
            }) {
                Text("Pas encore de compte ?")
                    .foregroundColor(.orange)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.orange, lineWidth: 2)
                    )
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 30)
        }
        .onAppear {
            checkIfLoggedIn()
        }
    }
    
    func login() {
        guard let url = URL(string: "https://solervis.fr/api/user/auth/login") else { return }
        
        let body: [String: Any] = ["email": email, "password": password]
        let finalBody = try? JSONSerialization.data(withJSONObject: body)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = finalBody
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            guard let data = data else { return }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let token = json["token"] as? String,
                   let userId = json["id"] as? String {
                    DispatchQueue.main.async {
                        self.userSettings.userId = userId
                        self.userSettings.token = token
                        self.userSettings.isUserLoggedIn = true
                    }
                } else {
                    DispatchQueue.main.async {
                        self.errorMessage = "Invalid login credentials"
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to decode response"
                }
            }
        }.resume()
    }

    func checkIfLoggedIn() {
        if let token = UserDefaults.standard.string(forKey: "token") {
            refreshAuthToken(token: token)
        }
    }
    
    func refreshAuthToken(token: String) {
        guard let url = URL(string: "https://solervis.fr/api/user/auth/refresh") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            guard let data = data else { return }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let newToken = json["token"] as? String {
                    DispatchQueue.main.async {
                        self.userSettings.token = newToken
                        self.userSettings.isUserLoggedIn = true
                    }
                } else {
                    DispatchQueue.main.async {
                        self.errorMessage = "Failed to refresh token"
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to decode response"
                }
            }
        }.resume()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(UserSettings())
    }
}
